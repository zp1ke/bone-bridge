package org.bone.bridge.back.app.api;

import org.bone.bridge.back.app.config.Security;
import org.bone.bridge.back.app.model.User;
import org.bone.bridge.back.app.service.OrganizationService;
import org.bone.bridge.back.app.service.UserService;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.service.UserConfigService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(UserController.class)
@ContextConfiguration(classes = UserController.class)
@Import(Security.class)
public class UserControllerTests {
    @Autowired
    MockMvc mockMvc;

    @MockitoBean
    UserConfigService userConfigService;

    @MockitoBean
    UserService userService;

    @MockitoBean
    OrganizationService organizationService;

    @Test
    public void profile_whenUserNotAuthenticated_thenReturnsForbidden() throws Exception {
        mockMvc
            .perform(get(Constants.USERS_PATH + "/profile"))
            .andExpect(status().isForbidden());
    }

    @Test
    public void profile_whenUserAuthenticated_thenReturnsUserProfile() throws Exception {
        var user = User.builder()
            .uid("uid")
            .name("name")
            .email("email")
            .build();

        when(userService.userFromAuthToken(anyString())).thenReturn(user);

        mockMvc
            .perform(
                get(Constants.USERS_PATH + "/profile")
                    .header(Constants.AUTH_HEADER, "token"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.name").value(user.getName()))
            .andExpect(jsonPath("$.email").value(user.getEmail()));
    }
}
