package org.bone.bridge.back.products.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.data.model.BaseEntity;

@Entity
@Table(name = "products")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
public class Product extends BaseEntity {
    @Column(nullable = false)
    private String name;
}
