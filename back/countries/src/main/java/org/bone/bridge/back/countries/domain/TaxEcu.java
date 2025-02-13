package org.bone.bridge.back.countries.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.config.model.BaseEntity;
import org.bone.bridge.back.config.model.TaxData;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.countries.model.Country;

@Entity
@Table(name = "taxes_ecu")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
@NoArgsConstructor
public class TaxEcu extends BaseEntity implements TaxData {
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

    @Override
    public String getCountryCode() {
        return Country.ECU.name();
    }
}
