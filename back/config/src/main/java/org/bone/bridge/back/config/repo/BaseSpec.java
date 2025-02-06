package org.bone.bridge.back.config.repo;

import java.time.OffsetDateTime;
import org.bone.bridge.back.config.model.BaseEntity;
import org.springframework.data.jpa.domain.Specification;

public class BaseSpec {
    public static <T extends BaseEntity> Specification<T> createdBetween(OffsetDateTime from, OffsetDateTime to) {
        return (root, query, builder)
            -> builder.between(root.get("createdAt"), from, to);
    }
}
