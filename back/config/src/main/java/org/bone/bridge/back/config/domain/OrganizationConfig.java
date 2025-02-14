package org.bone.bridge.back.config.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.config.model.BaseEntity;

@Entity
@Table(name = "organizations_configs")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
@NoArgsConstructor
public class OrganizationConfig extends BaseEntity {
    @Size(min = 3, max = 50)
    @Column(name = "organization_code", nullable = false, length = 50)
    private String organizationCode;

    @Min(1)
    @Column(name = "max_products", nullable = false)
    private Short maxProducts;
}
