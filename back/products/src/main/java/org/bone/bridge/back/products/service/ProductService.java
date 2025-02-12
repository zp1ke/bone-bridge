package org.bone.bridge.back.products.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.error.InvalidDataException;
import org.bone.bridge.back.config.service.OrganizationConfigService;
import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.countries.service.CountryService;
import org.bone.bridge.back.products.domain.Product;
import org.bone.bridge.back.products.domain.ProductTax;
import org.bone.bridge.back.products.model.dto.ProductTaxDto;
import org.bone.bridge.back.products.repo.ProductRepo;
import org.bone.bridge.back.products.repo.ProductTaxRepo;
import org.springframework.data.util.Pair;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepo productRepo;

    private final ProductTaxRepo productTaxRepo;

    private final OrganizationConfigService organizationConfigService;

    private final CountryService countryService;

    @NonNull
    public Pair<Product, Map<Country, List<ProductTax>>> create(@NonNull String organizationCode,
                                                                @NonNull Product product,
                                                                @Nullable Map<Country, List<ProductTaxDto>> taxes) throws InvalidDataException {
        var maxProducts = organizationConfigService.organizationMaxProducts(organizationCode);
        var productsCount = countProductsOfOrganization(organizationCode);
        if (productsCount >= maxProducts) {
            throw new InvalidDataException("error.organization_max_products_reached");
        }

        validateTaxes(taxes);

        product.setOrganizationCode(organizationCode);
        product.setCode(availableCode(organizationCode, product.getCode()));
        var saved = productRepo.save(product);
        var productTaxes = saveTaxes(saved, taxes);
        return Pair.of(saved, productTaxes);
    }

    @NonNull
    public Pair<Product, Map<Country, List<ProductTax>>> save(@NonNull Product product,
                                                              @Nullable Map<Country, List<ProductTaxDto>> taxes) throws InvalidDataException {
        validateTaxes(taxes);

        var saved = productRepo.save(product);
        var productTaxes = saveTaxes(saved, taxes);
        return Pair.of(saved, productTaxes);
    }

    private void validateTaxes(@Nullable Map<Country, List<ProductTaxDto>> taxes) throws InvalidDataException {
        if (taxes != null) {
            for (var country : taxes.keySet()) {
                var countryTaxes = taxes.get(country).stream().collect(
                    Collectors.toMap(ProductTaxDto::getTaxType, ProductTaxDto::getPercentage)
                );
                if (countryService.taxesAreNotValid(country, countryTaxes)) {
                    throw new InvalidDataException("error.invalid_country_taxes");
                }
            }
        }
    }

    @NonNull
    private Map<Country, List<ProductTax>> saveTaxes(@NonNull Product product,
                                                     @Nullable Map<Country, List<ProductTaxDto>> taxes) {
        var map = new HashMap<Country, List<ProductTax>>();
        if (taxes != null) {
            for (var country : taxes.keySet()) {
                productTaxRepo.deleteAllByProductAndCountry(product, country);

                var countryProductTaxes = taxes.get(country);
                var countryTaxes = new ArrayList<ProductTax>(countryProductTaxes.size());
                for (var tax : countryProductTaxes) {
                    var productTax = ProductTax.builder()
                        .product(product)
                        .country(country)
                        .taxType(tax.getTaxType())
                        .percentage(tax.getPercentage())
                        .build();
                    countryTaxes.add(productTaxRepo.save(productTax));
                }

                map.put(country, countryTaxes);
            }
        }
        return map;
    }

    public int countProductsOfOrganization(@NonNull String organizationCode) {
        return productRepo.countByOrganizationCode(organizationCode);
    }

    @Nullable
    public String availableCode(@NonNull String organizationCode, @Nullable String code) {
        if (code != null) {
            var codeExists = productRepo.existsByOrganizationCodeAndCode(organizationCode, code);
            return codeExists ? null : code;
        }
        return null;
    }

    @Nullable
    public Product productOfOrganizationByCode(@NonNull String organizationCode, @NonNull String code) {
        return productRepo.findOneByOrganizationCodeAndCode(organizationCode, code).orElse(null);
    }
}
