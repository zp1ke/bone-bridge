package org.bone.bridge.back.config.repo;

import java.util.Optional;
import org.bone.bridge.back.config.domain.OrganizationConfig;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface OrganizationConfigRepo extends JpaRepository<OrganizationConfig, Long>, JpaSpecificationExecutor<OrganizationConfig> {
    Optional<OrganizationConfig> findByOrganizationCode(String organizationCode);
}
