package org.bone.bridge.back.countries.service;

import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Validator;
import java.util.Optional;
import java.util.Set;
import org.bone.bridge.back.countries.domain.OrganizationEcu;
import org.bone.bridge.back.countries.model.ecu.LegalIdType;
import org.bone.bridge.back.countries.model.ecu.OrganizationEcuData;
import org.bone.bridge.back.countries.repo.OrganizationEcuRepo;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.fail;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

public class OrganizationEcuServiceTests {
    OrganizationEcuRepo organizationEcuRepo;

    Validator validator;

    OrganizationEcuService organizationEcuService;

    @BeforeEach
    void setUp() {
        organizationEcuRepo = Mockito.mock(OrganizationEcuRepo.class);
        validator = Mockito.mock(Validator.class);
        organizationEcuService = new OrganizationEcuService(organizationEcuRepo, validator);
    }

    @Test
    void testWhenCreateOrganizationEcuDataThenReturnOrganizationEcuData() throws ConstraintViolationException {
        var data = OrganizationEcuData.builder()
            .organizationCode("organizationCode")
            .name("name")
            .email("email")
            .legalId("legalId")
            .legalIdType(LegalIdType.DNI)
            .build();
        var organization = OrganizationEcu.builder()
            .organizationCode(data.getOrganizationCode())
            .name(data.getName())
            .email(data.getEmail())
            .legalId(data.getLegalId())
            .legalIdType(data.getLegalIdType())
            .build();

        when(validator.validate(data)).thenReturn(Set.of());
        when(organizationEcuRepo.findOneByOrganizationCode(data.getOrganizationCode())).thenReturn(Optional.empty());
        when(organizationEcuRepo.existsByLegalId(data.getLegalId())).thenReturn(false);
        when(organizationEcuRepo.save(any())).thenReturn(organization);

        var result = organizationEcuService.save(data);
        assertEquals(data, result);
    }

    @Test
    void testWhenUpdateOrganizationEcuDataThenReturnOrganizationEcuData() throws ConstraintViolationException {
        var data = OrganizationEcuData.builder()
            .organizationCode("organizationCode")
            .name("name")
            .email("email")
            .legalId("legalId")
            .legalIdType(LegalIdType.DNI)
            .build();
        var organization = OrganizationEcu.builder()
            .organizationCode(data.getOrganizationCode())
            .name(data.getName())
            .email(data.getEmail())
            .legalId(data.getLegalId())
            .legalIdType(data.getLegalIdType())
            .build();

        when(validator.validate(data)).thenReturn(Set.of());
        when(organizationEcuRepo.findOneByOrganizationCode(data.getOrganizationCode())).thenReturn(Optional.of(organization));
        when(organizationEcuRepo.existsByLegalIdAndOrganizationCodeIsNot(data.getLegalId(), data.getOrganizationCode())).thenReturn(false);
        when(organizationEcuRepo.save(any())).thenReturn(organization);

        var result = organizationEcuService.save(data);
        assertEquals(data, result);
    }

    @Test
    void testWhenCreateExistingLegalIdOrganizationEcuDataThenThrowConstraintViolationException() {
        var data = OrganizationEcuData.builder()
            .organizationCode("organizationCode")
            .name("name")
            .email("email")
            .legalId("legalId")
            .legalIdType(LegalIdType.DNI)
            .build();

        when(validator.validate(data)).thenReturn(Set.of());
        when(organizationEcuRepo.findOneByOrganizationCode(data.getOrganizationCode())).thenReturn(Optional.empty());
        when(organizationEcuRepo.existsByLegalId(data.getLegalId())).thenReturn(true);

        try {
            organizationEcuService.save(data);
            fail("ConstraintViolationException was not thrown");
        } catch (ConstraintViolationException e) {
            assertEquals("error.legalIdAlreadyExists", e.getMessage());
        }
    }

    @Test
    void testWhenUpdateExistingLegalIdOrganizationEcuDataThenThrowConstraintViolationException() {
        var data = OrganizationEcuData.builder()
            .organizationCode("organizationCode")
            .name("name")
            .email("email")
            .legalId("legalId")
            .legalIdType(LegalIdType.DNI)
            .build();
        var organization = OrganizationEcu.builder()
            .organizationCode(data.getOrganizationCode())
            .name(data.getName())
            .email(data.getEmail())
            .legalId(data.getLegalId() + "0")
            .legalIdType(data.getLegalIdType())
            .build();

        when(validator.validate(data)).thenReturn(Set.of());
        when(organizationEcuRepo.findOneByOrganizationCode(data.getOrganizationCode())).thenReturn(Optional.of(organization));
        when(organizationEcuRepo.existsByLegalIdAndOrganizationCodeIsNot(data.getLegalId(), data.getOrganizationCode())).thenReturn(true);

        try {
            organizationEcuService.save(data);
            fail("ConstraintViolationException was not thrown");
        } catch (ConstraintViolationException e) {
            assertEquals("error.legalIdAlreadyExists", e.getMessage());
        }
    }
}
