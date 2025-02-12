package org.bone.bridge.back.countries.model;

import org.bone.bridge.back.countries.model.ecu.LegalIdType;
import org.bone.bridge.back.countries.model.ecu.OrganizationEcuData;
import org.junit.jupiter.api.Test;
import org.testcontainers.shaded.com.fasterxml.jackson.databind.ObjectMapper;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;

public class OrganizationDataJsonTests {
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Test
    public void testDeserializationToEcu() throws Exception {
        var organizationData = OrganizationEcuData.builder()
            .name("Organization")
            .email("org@mail.com")
            .phone("123456789")
            .address("Street 123")
            .legalId("1234567890")
            .legalIdType(LegalIdType.DNI)
            .build();
        var json = String.format("""
                {
                    "country": "ECU",
                    "name": "%s",
                    "email": "%s",
                    "phone": "%s",
                    "address": "%s",
                    "legalId": "%s",
                    "legalIdType": "%s"
                }
                """,
            organizationData.getName(),
            organizationData.getEmail(),
            organizationData.getPhone(),
            organizationData.getAddress(),
            organizationData.getLegalId(),
            organizationData.getLegalIdType().name());
        var parsed = objectMapper.readValue(json, OrganizationData.class);
        assertInstanceOf(OrganizationEcuData.class, parsed);
        assertEquals(organizationData, parsed);
    }
}
