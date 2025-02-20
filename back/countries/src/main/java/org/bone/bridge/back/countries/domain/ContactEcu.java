package org.bone.bridge.back.countries.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.config.model.BaseEntity;
import org.bone.bridge.back.countries.model.ecu.LegalIdType;

@Entity
@Table(name = "contacts_ecu")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
@NoArgsConstructor
public class ContactEcu extends BaseEntity {
    @Size(min = 3, max = 50)
    @Column(name = "contact_code", nullable = false, length = 50, unique = true)
    private String contactCode;

    @Size(min = 3, max = 255)
    @Column(nullable = false)
    private String name;

    @Email
    @Size(min = 3, max = 255)
    @Column(nullable = false)
    private String email;

    @Size(min = 3, max = 50)
    @Column(name = "legal_id", nullable = false, length = 50, unique = true)
    private String legalId;

    @Enumerated(EnumType.STRING)
    @NotNull
    @Column(name = "legal_id_type", nullable = false, length = 50)
    private LegalIdType legalIdType;

    @Size(max = 100)
    @Column(length = 100)
    private String phone;

    @Size(max = 500)
    @Column(length = 500)
    private String address;
}
