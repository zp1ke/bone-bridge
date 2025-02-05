package org.bone.bridge.back.app.repo;

import org.bone.bridge.back.app.domain.Organization;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface OrganizationRepo extends JpaRepository<Organization, Long>, JpaSpecificationExecutor<Organization> {
}
