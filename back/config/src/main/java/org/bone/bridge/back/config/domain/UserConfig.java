package org.bone.bridge.back.config.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.config.model.BaseEntity;

@Entity
@Table(name = "users_configs")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
public class UserConfig extends BaseEntity {
    @Size(min = 3, max = 50)
    @Column(name = "user_id", nullable = false, length = 50)
    private String userId;

    @Min(1)
    @Column(name = "max_organizations", nullable = false)
    private Short maxOrganizations;
}
