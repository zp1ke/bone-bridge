package org.bone.bridge.back.contacts.service;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.error.InvalidDataException;
import org.bone.bridge.back.config.service.OrganizationConfigService;
import org.bone.bridge.back.contacts.domain.Contact;
import org.bone.bridge.back.contacts.repo.ContactRepo;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ContactService {
    private final ContactRepo contactRepo;

    private final OrganizationConfigService organizationConfigService;

    @NonNull
    public Contact create(@NonNull String organizationCode,
                          @NonNull Contact contact) throws InvalidDataException {
        var maxContacts = organizationConfigService.organizationMaxContacts(organizationCode);
        var contactsCount = countContactsOfOrganization(organizationCode);
        if (contactsCount >= maxContacts) {
            throw new InvalidDataException("error.organization_max_contacts_reached");
        }

        contact.setOrganizationCode(organizationCode);
        contact.setCode(availableCode(organizationCode, contact.getCode()));
        return contactRepo.save(contact);
    }

    @NonNull
    public Contact save(@NonNull Contact contact) throws InvalidDataException {
        return contactRepo.save(contact);
    }

    public int countContactsOfOrganization(@NonNull String organizationCode) {
        return contactRepo.countByOrganizationCode(organizationCode);
    }

    @Nullable
    public String availableCode(@NonNull String organizationCode, @Nullable String code) {
        if (code != null) {
            var codeExists = contactRepo.existsByOrganizationCodeAndCode(organizationCode, code);
            return codeExists ? null : code;
        }
        return null;
    }

    @Nullable
    public Contact contactOfOrganizationByCode(@NonNull String organizationCode, @NonNull String code) {
        return contactRepo.findOneByOrganizationCodeAndCode(organizationCode, code).orElse(null);
    }
}
