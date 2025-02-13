package org.bone.bridge.back.countries.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.config.model.BaseEntity;
import org.bone.bridge.back.config.model.TaxType;

@Entity
@Table(name = "taxes_ecu")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
public class TaxEcu extends BaseEntity {
    @Size(min = 3, max = 50)
    @Column(name = "sri_code", nullable = false)
    private String sriCode;

    @Size(min = 3, max = 255)
    @Column(nullable = false)
    private String name;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "tax_type", nullable = false, length = 50)
    private TaxType taxType;

    @Min(0)
    @Column(nullable = false, precision = 4, scale = 4)
    private BigDecimal percentage;

    @Column(nullable = false)
    private boolean enabled;
}
