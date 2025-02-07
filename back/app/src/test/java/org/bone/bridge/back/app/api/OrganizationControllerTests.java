package org.bone.bridge.back.app.api;

import org.bone.bridge.back.app.config.Security;
import org.bone.bridge.back.app.domain.Organization;
import org.bone.bridge.back.app.model.User;
import org.bone.bridge.back.app.service.OrganizationService;
import org.bone.bridge.back.app.service.UserService;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.service.UserConfigService;
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
import static org.mockito.Mockito.when;
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
    UserConfigService userConfigService;

    @MockitoBean
    UserService userService;

    @MockitoBean
    OrganizationService organizationService;

    @Test
    void create_whenUserNotAuthenticated_thenReturnsForbidden() throws Exception {
        mockMvc
            .perform(post(Constants.ORGANIZATIONS_PATH))
            .andExpect(status().isForbidden());
    }

    @Test
    void create_whenUserAuthenticatedAndMaxOrganizationsReached_thenReturnsBadRequest() throws Exception {
        var user = User.builder()
            .uid("uid")
            .name("name")
            .email("email")
            .build();

        when(userService.userFromAuthToken(anyString())).thenReturn(user);
        when(userConfigService.userMaxOrganizations(user.getUid())).thenReturn((short) 1);
        when(organizationService.countOrganizationsOfUser(user)).thenReturn((short) 1);

        mockMvc
            .perform(
                post(Constants.ORGANIZATIONS_PATH)
                    .header(Constants.AUTH_HEADER, "token")
                    .content("{ \"code\": \"code\", \"name\": \"name\" }")
                    .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isBadRequest());
    }

    @Test
    void create_whenUserAuthenticatedAndMaxOrganizationsNotReached_thenReturnsCreated() throws Exception {
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
        when(userConfigService.userMaxOrganizations(user.getUid())).thenReturn((short) 1);
        when(organizationService.countOrganizationsOfUser(user)).thenReturn((short) 0);
        when(organizationService.availableCode(user, "code")).thenReturn("code");
        when(organizationService.save(any())).thenReturn(organization);

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
}
