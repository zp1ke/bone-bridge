package org.bone.bridge.back.app.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.config.model.BaseEntity;

@Entity
@Table(name = "organizations")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
public class Organization extends BaseEntity {
    @Column(nullable = false)
    private String name;

    @Column(name = "user_id", nullable = false)
    private String userId;
}
