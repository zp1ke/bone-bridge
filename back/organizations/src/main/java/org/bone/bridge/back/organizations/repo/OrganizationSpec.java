package org.bone.bridge.back.organizations.repo;

import java.time.OffsetDateTime;
import org.bone.bridge.back.organizations.domain.Organization;
import org.bone.bridge.back.config.repo.BaseSpec;
import org.springframework.data.jpa.domain.Specification;

public class OrganizationSpec {
    public static Specification<Organization> createdBetween(OffsetDateTime from, OffsetDateTime to) {
        return BaseSpec.createdBetween(from, to);
    }
}
