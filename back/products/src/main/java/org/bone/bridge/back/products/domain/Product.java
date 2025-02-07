package org.bone.bridge.back.products.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.config.model.BaseEntity;

@Entity
@Table(name = "products")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
public class Product extends BaseEntity {
    @Column(name = "user_id", nullable = false, length = 50)
    private String userId;

    @Size(min = 3, max = 255)
    @Column(nullable = false)
    private String name;

    @Min(0)
    @Column(name = "unit_price", nullable = false, precision = 10, scale = 4)
    private BigDecimal unitPrice;
}
