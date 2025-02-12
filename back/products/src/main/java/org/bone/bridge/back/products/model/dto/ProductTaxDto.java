package org.bone.bridge.back.products.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import lombok.Builder;
import lombok.Getter;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.products.domain.ProductTax;
import org.springframework.lang.NonNull;

@Getter
@Builder
public class ProductTaxDto {
    @NotNull
    private TaxType taxType;

    @Min(0)
    private BigDecimal percentage;

    @NonNull
    public static ProductTaxDto from(@NonNull ProductTax productTax) {
        return ProductTaxDto.builder()
            .taxType(productTax.getTaxType())
            .percentage(productTax.getPercentage())
            .build();
    }
}
