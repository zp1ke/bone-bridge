package org.bone.bridge.back.products.service;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.error.InvalidDataException;
import org.bone.bridge.back.config.service.OrganizationConfigService;
import org.bone.bridge.back.products.domain.Product;
import org.bone.bridge.back.products.repo.ProductRepo;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepo productRepo;

    private final OrganizationConfigService organizationConfigService;

    @NonNull
    public Product create(@NonNull String organizationCode,
                          @NonNull Product product) throws InvalidDataException {
        var maxProducts = organizationConfigService.organizationMaxProducts(organizationCode);
        var productsCount = countProductsOfOrganization(organizationCode);
        if (productsCount >= maxProducts) {
            throw new InvalidDataException("error.organization_max_products_reached");
        }
        product.setOrganizationCode(organizationCode);
        product.setCode(availableCode(organizationCode, product.getCode()));
        return productRepo.save(product);
    }

    @NonNull
    public Product save(@NonNull Product product) {
        return productRepo.save(product);
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
}
