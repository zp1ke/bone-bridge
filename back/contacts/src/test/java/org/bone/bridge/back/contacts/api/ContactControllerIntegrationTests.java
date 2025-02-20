package org.bone.bridge.back.contacts.api;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.contacts.TestcontainersConfig;
import org.bone.bridge.back.contacts.model.dto.ContactDto;
import org.bone.bridge.back.contacts.repo.ContactRepo;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.context.annotation.Import;
import org.springframework.http.HttpStatus;
import static org.bone.bridge.back.utils.test.Assertions.assertBigDecimalEquals;
import static org.junit.jupiter.api.Assertions.*;

@Import(TestcontainersConfig.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class ContactControllerIntegrationTests {
    @Autowired
    TestRestTemplate testRestTemplate;

    @Autowired
    ContactRepo contactRepo;

    @Test
    void testCreateContact() {
        var organizationCode = "org-1";
        var dto = ContactDto.builder()
            .code("contact-1")
            .name("Contact 1")
            .email("contact@mail.com")
            .build();

        var url = String.format("%s/%s%s", Constants.ORGANIZATIONS_PATH, organizationCode, Constants.CONTACTS_PATH);
        var response = testRestTemplate.postForEntity(url, dto, ContactDto.class);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(dto.getCode(), response.getBody().getCode());
        assertEquals(dto.getName(), response.getBody().getName());
        assertEquals(dto.getEmail(), response.getBody().getEmail());

        var contact = contactRepo.findOneByOrganizationCodeAndCode(organizationCode, dto.getCode());
        assertTrue(contact.isPresent());
        assertEquals(dto.getCode(), contact.get().getCode());
        assertEquals(dto.getName(), contact.get().getName());
        assertEquals(dto.getEmail(), contact.get().getEmail());
    }
}
