package org.bone.bridge.back.organizations.repo;

import java.util.List;
import java.util.Optional;
import org.bone.bridge.back.organizations.domain.Organization;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface OrganizationRepo extends JpaRepository<Organization, Long>, JpaSpecificationExecutor<Organization> {
    int countByUserId(String userId);

    List<Organization> findAllByUserId(String userId);

    Optional<Organization> findOneByUserIdAndCode(String userId, String code);

    boolean existsByUserIdAndCode(String userId, String code);
}
