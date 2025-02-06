package org.bone.bridge.back.app.repo;

import java.time.OffsetDateTime;
import org.bone.bridge.back.app.domain.Organization;
import org.bone.bridge.back.config.repo.BaseSpec;
import org.springframework.data.jpa.domain.Specification;

public class OrganizationSpec {
    public static Specification<Organization> createdBetween(OffsetDateTime from, OffsetDateTime to) {
        return BaseSpec.createdBetween(from, to);
    }
}
