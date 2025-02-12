package org.bone.bridge.back.products.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.config.model.CoreEntity;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.countries.model.Country;

@Entity
@Table(name = "products_taxes")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
public class ProductTax extends CoreEntity {
    @Size(min = 3, max = 255)
    @Column(name = "organization_code", nullable = false, length = 50)
    private String organizationCode;

    @NotNull
    @ManyToOne(optional = false)
    @JoinColumn(name = "product_id", referencedColumnName = "id")
    private Product product;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "tax_type", nullable = false, length = 50)
    private TaxType taxType;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private Country country;

    @Min(0)
    @Column(nullable = false, precision = 4, scale = 4)
    private BigDecimal percentage;
}
