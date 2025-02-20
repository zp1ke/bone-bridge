package org.bone.bridge.back.contacts.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.config.model.BaseEntity;

@Entity
@Table(name = "contacts")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
@NoArgsConstructor
public class Contact extends BaseEntity {
    @Column(name = "organization_code", nullable = false, length = 50)
    private String organizationCode;

    @Size(min = 3, max = 255)
    @Column(nullable = false)
    private String name;

    @Email
    @Size(min = 3, max = 255)
    @Column(nullable = false)
    private String email;
}
