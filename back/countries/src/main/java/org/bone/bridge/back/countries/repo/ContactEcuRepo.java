package org.bone.bridge.back.countries.repo;

import java.util.Optional;
import org.bone.bridge.back.countries.domain.ContactEcu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ContactEcuRepo extends JpaRepository<ContactEcu, Long>, JpaSpecificationExecutor<ContactEcu> {
    Optional<ContactEcu> findOneByContactCode(String contactCode);

    boolean existsByLegalIdAndContactCodeIsNot(String legalId, String contactCode);

    boolean existsByLegalId(String legalId);
}
