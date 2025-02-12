package org.bone.bridge.back.products.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.Builder;
import lombok.Getter;
import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.products.domain.Product;
import org.bone.bridge.back.products.domain.ProductTax;
import org.springframework.lang.NonNull;

@Getter
@Builder
public class ProductDto {
    private final String code;

    @Size(min = 3, max = 255)
    private String name;

    @Min(0)
    private BigDecimal unitPrice;

    private Map<Country, List<ProductTaxDto>> taxes;

    @NonNull
    public static ProductDto from(@NonNull Product product,
                                  @NonNull Map<Country, List<ProductTax>> taxes) {
        var dtoTaxes = new HashMap<Country, List<ProductTaxDto>>(taxes.size());
        for (var entry : taxes.entrySet()) {
            dtoTaxes.put(entry.getKey(), entry.getValue().stream()
                .map(ProductTaxDto::from)
                .toList());
        }

        return ProductDto.builder()
            .code(product.getCode())
            .name(product.getName())
            .unitPrice(product.getUnitPrice())
            .taxes(dtoTaxes)
            .build();
    }
}
