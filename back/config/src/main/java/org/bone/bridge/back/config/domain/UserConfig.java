package org.bone.bridge.back.config.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.data.model.BaseEntity;

@Entity
@Table(name = "user_configs")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
public class UserConfig extends BaseEntity {
    @Column(name = "user_id", nullable = false)
    private String userId;

    @Column(name = "max_organizations", nullable = false)
    private Short maxOrganizations;

    @Column(name = "max_products", nullable = false)
    private Short maxProducts;
}
