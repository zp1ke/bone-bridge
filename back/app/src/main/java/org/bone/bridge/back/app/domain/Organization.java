package org.bone.bridge.back.app.domain;

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
@Table(name = "organizations")
@Getter
@Setter
@SuperBuilder(toBuilder = true)
@NoArgsConstructor
public class Organization extends BaseEntity {
    @Size(min = 3, max = 255)
    @Column(nullable = false)
    private String name;

    @Size(min = 3, max = 50)
    @Column(name = "user_id", nullable = false, length = 50)
    private String userId;

    @Email
    @Size(min = 3, max = 255)
    @Column(nullable = false)
    private String email;

    @Size(max = 100)
    @Column(length = 100)
    private String phone;

    @Size(max = 500)
    @Column(length = 500)
    private String address;
}
