package org.bone.bridge.back.config.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import java.time.OffsetDateTime;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.utils.StringUtils;
import org.bone.bridge.back.utils.model.StringConfig;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Getter
@Setter
@MappedSuperclass
@SuperBuilder(toBuilder = true)
public abstract class BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(updatable = false, nullable = false)
    @Setter(AccessLevel.NONE)
    private Long id;

    @Size(min = 3, max = 50)
    @Column(updatable = false, nullable = false, length = 50)
    private String code;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false, nullable = false)
    private OffsetDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    @PrePersist
    @PreUpdate
    void preUpdate() {
        if (StringUtils.isBlank(code)) {
            var codeConfig = StringConfig.builder()
                .lowercaseLetters(3)
                .numbers(3)
                .build();
            code = StringUtils.randomString(codeConfig);
        }
    }
}
