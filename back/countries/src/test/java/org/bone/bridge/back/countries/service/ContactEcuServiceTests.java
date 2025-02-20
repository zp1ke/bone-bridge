package org.bone.bridge.back.countries.service;

import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Validator;
import java.util.Optional;
import java.util.Set;
import org.bone.bridge.back.countries.domain.ContactEcu;
import org.bone.bridge.back.countries.model.ecu.ContactEcuData;
import org.bone.bridge.back.countries.model.ecu.LegalIdType;
import org.bone.bridge.back.countries.repo.ContactEcuRepo;
import org.bone.bridge.back.countries.service.ecu.ContactEcuService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.fail;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

public class ContactEcuServiceTests {
    ContactEcuRepo contactEcuRepo;

    Validator validator;

    ContactEcuService contactEcuService;

    @BeforeEach
    void setUp() {
        contactEcuRepo = Mockito.mock(ContactEcuRepo.class);
        validator = Mockito.mock(Validator.class);
        contactEcuService = new ContactEcuService(contactEcuRepo, validator);
    }

    @Test
    void testWhenCreateContactEcuDataThenReturnContactEcuData() throws ConstraintViolationException {
        var data = ContactEcuData.builder()
            .name("name")
            .email("email")
            .legalId("legalId")
            .legalIdType(LegalIdType.DNI)
            .build();
        var contactCode = "contactCode";
        var contact = ContactEcu.builder()
            .contactCode(contactCode)
            .name(data.getName())
            .email(data.getEmail())
            .legalId(data.getLegalId())
            .legalIdType(data.getLegalIdType())
            .build();

        when(validator.validate(data)).thenReturn(Set.of());
        when(contactEcuRepo.findOneByContactCode(contactCode)).thenReturn(Optional.empty());
        when(contactEcuRepo.existsByLegalId(data.getLegalId())).thenReturn(false);
        when(contactEcuRepo.save(any())).thenReturn(contact);

        var result = contactEcuService.save(contactCode, data);
        assertEquals(data, result);
    }

    @Test
    void testWhenUpdateContactEcuDataThenReturnContactEcuData() throws ConstraintViolationException {
        var data = ContactEcuData.builder()
            .name("name")
            .email("email")
            .legalId("legalId")
            .legalIdType(LegalIdType.DNI)
            .build();
        var contactCode = "contactCode";
        var contact = ContactEcu.builder()
            .contactCode(contactCode)
            .name(data.getName())
            .email(data.getEmail())
            .legalId(data.getLegalId())
            .legalIdType(data.getLegalIdType())
            .build();

        when(validator.validate(data)).thenReturn(Set.of());
        when(contactEcuRepo.findOneByContactCode(contactCode)).thenReturn(Optional.of(contact));
        when(contactEcuRepo.existsByLegalIdAndContactCodeIsNot(data.getLegalId(), contactCode)).thenReturn(false);
        when(contactEcuRepo.save(any())).thenReturn(contact);

        var result = contactEcuService.save(contactCode, data);
        assertEquals(data, result);
    }

    @Test
    void testWhenCreateExistingLegalIdContactEcuDataThenThrowConstraintViolationException() {
        var contactCode = "contactCode";
        var data = ContactEcuData.builder()
            .name("name")
            .email("email")
            .legalId("legalId")
            .legalIdType(LegalIdType.DNI)
            .build();

        when(validator.validate(data)).thenReturn(Set.of());
        when(contactEcuRepo.findOneByContactCode(contactCode)).thenReturn(Optional.empty());
        when(contactEcuRepo.existsByLegalId(data.getLegalId())).thenReturn(true);

        try {
            contactEcuService.save(contactCode, data);
            fail("ConstraintViolationException was not thrown");
        } catch (ConstraintViolationException e) {
            assertEquals("error.legalIdAlreadyExists", e.getMessage());
        }
    }

    @Test
    void testWhenUpdateExistingLegalIdContactEcuDataThenThrowConstraintViolationException() {
        var contactCode = "contactCode";
        var data = ContactEcuData.builder()
            .name("name")
            .email("email")
            .legalId("legalId")
            .legalIdType(LegalIdType.DNI)
            .build();
        var contact = ContactEcu.builder()
            .contactCode(contactCode)
            .name(data.getName())
            .email(data.getEmail())
            .legalId(data.getLegalId() + "0")
            .legalIdType(data.getLegalIdType())
            .build();

        when(validator.validate(data)).thenReturn(Set.of());
        when(contactEcuRepo.findOneByContactCode(contactCode)).thenReturn(Optional.of(contact));
        when(contactEcuRepo.existsByLegalIdAndContactCodeIsNot(data.getLegalId(), contactCode)).thenReturn(true);

        try {
            contactEcuService.save(contactCode, data);
            fail("ConstraintViolationException was not thrown");
        } catch (ConstraintViolationException e) {
            assertEquals("error.legalIdAlreadyExists", e.getMessage());
        }
    }
}
