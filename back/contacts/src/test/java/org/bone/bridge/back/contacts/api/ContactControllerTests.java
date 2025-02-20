package org.bone.bridge.back.contacts.api;

import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.contacts.domain.Contact;
import org.bone.bridge.back.contacts.service.ContactService;
import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.countries.model.ecu.ContactEcuData;
import org.bone.bridge.back.countries.model.ecu.LegalIdType;
import org.bone.bridge.back.countries.service.CountryService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ContactController.class)
@ContextConfiguration(classes = ContactController.class)
public class ContactControllerTests {
    @Autowired
    MockMvc mockMvc;

    @MockitoBean
    ContactService contactService;

    @MockitoBean
    CountryService countryService;

    @Test
    void create_thenReturnsCreated() throws Exception {
        var contact = Contact.builder()
            .code("code")
            .name("name")
            .build();

        when(contactService.create(any(), any())).thenReturn(contact);

        mockMvc
            .perform(
                post(Constants.ORGANIZATIONS_PATH + "/org" + Constants.CONTACTS_PATH)
                    .header(Constants.AUTH_HEADER, "token")
                    .content("{ \"code\": \"code\", \"name\": \"name\" }")
                    .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.code").value(contact.getCode()))
            .andExpect(jsonPath("$.name").value(contact.getName()));
    }

    @Test
    void update_whenContactNotFound_thenReturnsNotFound() throws Exception {
        when(contactService.contactOfOrganizationByCode("org", "code")).thenReturn(null);

        mockMvc
            .perform(
                put(Constants.ORGANIZATIONS_PATH + "/org" + Constants.CONTACTS_PATH + "/code")
                    .header(Constants.AUTH_HEADER, "token")
                    .content("{ \"name\": \"name\", \"email\": \"domain@email.com\" }")
                    .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isNotFound());
    }

    @Test
    void update_whenContactFound_thenReturnsOk() throws Exception {
        var contact = Contact.builder()
            .organizationCode("org")
            .code("code")
            .name("name")
            .build();

        when(contactService.contactOfOrganizationByCode("org", "code")).thenReturn(contact);
        when(contactService.save(any())).thenReturn(contact);

        mockMvc
            .perform(
                put(Constants.ORGANIZATIONS_PATH + "/org" + Constants.CONTACTS_PATH + "/code")
                    .header(Constants.AUTH_HEADER, "token")
                    .content("{ \"name\": \"name\", \"email\": \"domain@email.com\" }")
                    .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.code").value(contact.getCode()))
            .andExpect(jsonPath("$.name").value(contact.getName()));

        verifyNoInteractions(countryService);
    }

    @Test
    void update_whenContactFoundAndCountryData_thenReturnsOk() throws Exception {
        var contact = Contact.builder()
            .organizationCode("org")
            .code("code")
            .name("name")
            .email("domain@email.com")
            .build();
        var country = Country.ECU;
        var countryData = ContactEcuData.builder()
            .legalIdType(LegalIdType.DNI)
            .legalId("legalId")
            .name(contact.getName())
            .email(contact.getEmail())
            .build();

        when(contactService.contactOfOrganizationByCode("org", "code")).thenReturn(contact);
        when(contactService.save(any())).thenReturn(contact);
        when(countryService.saveContact(anyString(), any(ContactEcuData.class))).thenReturn(countryData);

        var request = String.format("""
                {
                    "name": "%s", "email": "%s", "countryData": {
                        "country": "%s", "legalIdType": "%s", "legalId": "%s", "name": "%s", "email": "%s"
                    }
                }""",
            contact.getName(), contact.getEmail(), country.name(),
            countryData.getLegalIdType().name(), countryData.getLegalId(), countryData.getName(), countryData.getEmail());
        mockMvc
            .perform(
                put(Constants.ORGANIZATIONS_PATH + "/org" + Constants.CONTACTS_PATH + "/code")
                    .header(Constants.AUTH_HEADER, "token")
                    .content(request)
                    .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.code").value(contact.getCode()))
            .andExpect(jsonPath("$.name").value(contact.getName()))
            .andExpect(jsonPath("$.countryData").exists());

        verify(countryService, times(1))
            .saveContact(anyString(), any(ContactEcuData.class));
    }
}
