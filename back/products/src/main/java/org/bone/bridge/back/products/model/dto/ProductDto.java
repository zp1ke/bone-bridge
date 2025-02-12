package org.bone.bridge.back.products.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import lombok.Builder;
import lombok.Getter;
import org.bone.bridge.back.products.domain.Product;
import org.springframework.lang.NonNull;

@Getter
@Builder
public class ProductDto {
    private final String code;

    @Size(min = 3, max = 255)
    private String name;

    @Min(0)
    private BigDecimal unitPrice;

    @NonNull
    public static ProductDto from(@NonNull Product product) {
        return ProductDto.builder()
            .code(product.getCode())
            .name(product.getName())
            .unitPrice(product.getUnitPrice())
            .build();
    }
}
