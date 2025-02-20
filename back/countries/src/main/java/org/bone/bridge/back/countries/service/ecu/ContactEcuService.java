package org.bone.bridge.back.countries.service.ecu;

import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Validator;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.countries.domain.ContactEcu;
import org.bone.bridge.back.countries.model.ContactData;
import org.bone.bridge.back.countries.model.ecu.ContactEcuData;
import org.bone.bridge.back.countries.repo.ContactEcuRepo;
import org.bone.bridge.back.countries.service.ContactService;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ContactEcuService implements ContactService<ContactEcuData> {
    private final ContactEcuRepo contactEcuRepo;

    private final Validator validator;

    @NonNull
    @Override
    public ContactEcuData save(@NonNull String contactCode,
                               @NonNull ContactData contactData) throws ConstraintViolationException {
        var data = (ContactEcuData) contactData;
        var violations = validator.validate(data);
        if (!violations.isEmpty()) {
            throw new ConstraintViolationException("error.invalidData", violations);
        }
        var byContactCode = contactEcuRepo.findOneByContactCode(contactCode);
        return byContactCode
            .map(contactEcu -> update(contactEcu, data))
            .orElseGet(() -> create(contactCode, data));
    }

    @Override
    public Class<ContactEcuData> getDataClass() {
        return ContactEcuData.class;
    }

    @NonNull
    private ContactEcuData create(@NonNull String contactCode,
                                  @NonNull ContactEcuData data) {
        if (contactEcuRepo.existsByLegalId(data.getLegalId())) {
            throw new ConstraintViolationException("error.legalIdAlreadyExists", Set.of());
        }
        var builder = ContactEcu.builder().contactCode(contactCode);
        return save(builder, data);
    }

    @NonNull
    private ContactEcuData update(@NonNull ContactEcu contactEcu,
                                  @NonNull ContactEcuData data) throws ConstraintViolationException {
        if (!data.getLegalId().equals(contactEcu.getLegalId()) &&
            contactEcuRepo.existsByLegalIdAndContactCodeIsNot(data.getLegalId(), contactEcu.getContactCode())) {
            throw new ConstraintViolationException("error.legalIdAlreadyExists", Set.of());
        }
        return save(contactEcu.toBuilder(), data);
    }

    @NonNull
    private ContactEcuData save(@NonNull ContactEcu.ContactEcuBuilder<?, ?> builder,
                                @NonNull ContactEcuData data) {
        var contact = builder
            .name(data.getName())
            .email(data.getEmail())
            .legalId(data.getLegalId())
            .legalIdType(data.getLegalIdType())
            .phone(data.getPhone())
            .address(data.getAddress())
            .build();
        contact = contactEcuRepo.save(contact);
        return ContactEcuData.from(contact);
    }
}
