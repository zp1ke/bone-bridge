package org.bone.bridge.back.module.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.config.model.BaseEntity;

@Entity
@Table(name = "user_configs")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
public class Entity extends BaseEntity {
    @Column(name = "user_id", nullable = false)
    private String userId;
}
