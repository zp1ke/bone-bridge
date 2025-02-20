package org.bone.bridge.back.sales.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Embedded;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.config.model.BaseEntity;
import org.bone.bridge.back.countries.model.ContactData;
import org.bone.bridge.back.countries.model.OrganizationData;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Entity
@Table(name = "estimates")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
public class Estimate extends BaseEntity {
    @Column(name = "organization_code", nullable = false, length = 50)
    private String organizationCode;

    @Size(min = 3, max = 255)
    @Column(nullable = false)
    private String name;

    @Size(min = 3, max = 50)
    @Column(name = "sequence_number", nullable = false)
    private String sequenceNumber;

    @Column(nullable = false)
    private OffsetDateTime datetime;

    @Embedded
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(nullable = false)
    private OrganizationData organization;

    @Embedded
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(nullable = false)
    private ContactData contact;

    @Min(0)
    @Column(precision = 10, scale = 4)
    private BigDecimal discount;
}
