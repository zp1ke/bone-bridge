package org.bone.bridge.back.contacts.repo;

import java.util.Optional;
import org.bone.bridge.back.contacts.domain.Contact;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ContactRepo extends JpaRepository<Contact, Long>, JpaSpecificationExecutor<Contact> {
    int countByOrganizationCode(String organizationCode);

    boolean existsByOrganizationCodeAndCode(String organizationCode, String code);

    Optional<Contact> findOneByOrganizationCodeAndCode(String organizationCode, String code);
}
