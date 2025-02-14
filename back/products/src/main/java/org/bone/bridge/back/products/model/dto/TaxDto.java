package org.bone.bridge.back.products.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import org.bone.bridge.back.config.model.TaxData;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.products.domain.ProductTax;
import org.springframework.lang.NonNull;

@Getter
@Builder
@EqualsAndHashCode
public class TaxDto {
    @Size(max = 50)
    private String code;

    @NotNull
    private TaxType taxType;

    @Min(0)
    private BigDecimal percentage;

    @NonNull
    public static TaxDto from(@NonNull ProductTax productTax) {
        return TaxDto.builder()
            .taxType(productTax.getTaxType())
            .percentage(productTax.getPercentage())
            .build();
    }

    @NonNull
    public static TaxDto from(@NonNull TaxData taxData) {
        return TaxDto.builder()
            .code(taxData.getCountryCode())
            .taxType(taxData.getTaxType())
            .percentage(taxData.getPercentage())
            .build();
    }
}
