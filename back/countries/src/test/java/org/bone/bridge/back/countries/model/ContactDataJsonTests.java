package org.bone.bridge.back.countries.model;

import org.bone.bridge.back.countries.model.ecu.ContactEcuData;
import org.bone.bridge.back.countries.model.ecu.LegalIdType;
import org.junit.jupiter.api.Test;
import org.testcontainers.shaded.com.fasterxml.jackson.databind.ObjectMapper;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;

public class ContactDataJsonTests {
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Test
    public void testDeserializationToEcu() throws Exception {
        var contactData = ContactEcuData.builder()
            .name("Contact")
            .email("contact@mail.com")
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
            contactData.getName(),
            contactData.getEmail(),
            contactData.getPhone(),
            contactData.getAddress(),
            contactData.getLegalId(),
            contactData.getLegalIdType().name());
        var parsed = objectMapper.readValue(json, ContactData.class);
        assertInstanceOf(ContactEcuData.class, parsed);
        assertEquals(contactData, parsed);
    }
}
