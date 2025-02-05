package org.bone.bridge.back.app.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import org.bone.bridge.back.data.model.BaseEntity;

@Entity
@Table(name = "organizations")
@Getter
@Setter
public class Organization extends BaseEntity {
    @Column(nullable = false)
    private String name;
}
