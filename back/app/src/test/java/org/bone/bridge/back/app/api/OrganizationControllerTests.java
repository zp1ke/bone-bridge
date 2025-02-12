package org.bone.bridge.back.app.api;

import org.bone.bridge.back.app.config.Security;
import org.bone.bridge.back.app.domain.Organization;
import org.bone.bridge.back.app.model.User;
import org.bone.bridge.back.app.service.OrganizationService;
import org.bone.bridge.back.app.service.UserService;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.countries.model.ecu.LegalIdType;
import org.bone.bridge.back.countries.model.ecu.OrganizationEcuData;
import org.bone.bridge.back.countries.service.CountryService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(OrganizationController.class)
@ContextConfiguration(classes = OrganizationController.class)
@Import(Security.class)
public class OrganizationControllerTests {
    @Autowired
    MockMvc mockMvc;

    @MockitoBean
    UserService userService;

    @MockitoBean
    OrganizationService organizationService;

    @MockitoBean
    CountryService countryService;

    @Test
    void create_whenUserNotAuthenticated_thenReturnsForbidden() throws Exception {
        mockMvc
            .perform(post(Constants.ORGANIZATIONS_PATH))
            .andExpect(status().isForbidden());
    }

    @Test
    void create_whenUserAuthenticated_thenReturnsCreated() throws Exception {
        var user = User.builder()
            .uid("uid")
            .name("name")
            .email("email")
            .build();
        var organization = Organization.builder()
            .userId("uid")
            .code("code")
            .name("name")
            .build();

        when(userService.userFromAuthToken(anyString())).thenReturn(user);
        when(organizationService.create(any(), anyString(), any())).thenReturn(organization);

        mockMvc
            .perform(
                post(Constants.ORGANIZATIONS_PATH)
                    .header(Constants.AUTH_HEADER, "token")
                    .content("{ \"code\": \"code\", \"name\": \"name\" }")
                    .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.code").value(organization.getCode()))
            .andExpect(jsonPath("$.name").value(organization.getName()));
    }

    @Test
    void update_whenUserNotAuthenticated_thenReturnsForbidden() throws Exception {
        mockMvc
            .perform(post(Constants.ORGANIZATIONS_PATH + "/code"))
            .andExpect(status().isForbidden());
    }

    @Test
    void update_whenUserAuthenticatedAndOrganizationNotFound_thenReturnsForbidden() throws Exception {
        var user = User.builder()
            .uid("uid")
            .name("name")
            .email("email")
            .build();

        when(userService.userFromAuthToken(anyString())).thenReturn(user);
        when(organizationService.organizationOfUserByCode(user, "code")).thenReturn(null);

        mockMvc
            .perform(
                post(Constants.ORGANIZATIONS_PATH + "/code")
                    .header(Constants.AUTH_HEADER, "token")
                    .content("{ \"name\": \"name\", \"email\": \"email\" }")
                    .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isForbidden());
    }

    @Test
    void update_whenUserAuthenticatedAndOrganizationFound_thenReturnsOk() throws Exception {
        var user = User.builder()
            .uid("uid")
            .name("name")
            .email("email")
            .build();
        var organization = Organization.builder()
            .userId("uid")
            .code("code")
            .name("name")
            .build();

        when(userService.userFromAuthToken(anyString())).thenReturn(user);
        when(organizationService.organizationOfUserByCode(user, "code")).thenReturn(organization);
        when(organizationService.save(any())).thenReturn(organization);

        mockMvc
            .perform(
                post(Constants.ORGANIZATIONS_PATH + "/code")
                    .header(Constants.AUTH_HEADER, "token")
                    .content("{ \"name\": \"name\", \"email\": \"domain@email.com\" }")
                    .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.code").value(organization.getCode()))
            .andExpect(jsonPath("$.name").value(organization.getName()));

        verifyNoInteractions(countryService);
    }

    @Test
    void update_whenUserAuthenticatedAndOrganizationFoundAndCountryData_thenReturnsOk() throws Exception {
        var user = User.builder()
            .uid("uid")
            .name("name")
            .email("email")
            .build();
        var organization = Organization.builder()
            .userId("uid")
            .code("code")
            .name("name")
            .email("domain@email.com")
            .build();
        var country = Country.ECU;
        var countryData = OrganizationEcuData.builder()
            .legalIdType(LegalIdType.DNI)
            .legalId("legalId")
            .name(organization.getName())
            .email(organization.getEmail())
            .build();

        when(userService.userFromAuthToken(anyString())).thenReturn(user);
        when(organizationService.organizationOfUserByCode(user, "code")).thenReturn(organization);
        when(organizationService.save(any())).thenReturn(organization);
        when(countryService.saveOrganization(anyString(), any(OrganizationEcuData.class))).thenReturn(countryData);

        var request = String.format("""
                {
                    "name": "%s", "email": "%s", "countryData": {
                        "country": "%s", "legalIdType": "%s", "legalId": "%s", "name": "%s", "email": "%s"
                    }
                }""",
            organization.getName(), organization.getEmail(), country.name(),
            countryData.getLegalIdType().name(), countryData.getLegalId(), countryData.getName(), countryData.getEmail());
        mockMvc
            .perform(
                post(Constants.ORGANIZATIONS_PATH + "/code")
                    .header(Constants.AUTH_HEADER, "token")
                    .content(request)
                    .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.code").value(organization.getCode()))
            .andExpect(jsonPath("$.name").value(organization.getName()))
            .andExpect(jsonPath("$.countryData").exists());

        verify(countryService, times(1))
            .saveOrganization(anyString(), any(OrganizationEcuData.class));
    }
}
