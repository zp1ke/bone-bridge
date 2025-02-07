package org.bone.bridge.back.countries.repo;

import java.util.Optional;
import org.bone.bridge.back.countries.domain.OrganizationEcu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface OrganizationEcuRepo extends JpaRepository<OrganizationEcu, Long>, JpaSpecificationExecutor<OrganizationEcu> {
    Optional<OrganizationEcu> findOneByOrganizationCode(String organizationCode);

    boolean existsByLegalIdAndOrganizationCodeIsNot(String legalId, String organizationCode);

    boolean existsByLegalId(String legalId);
}
