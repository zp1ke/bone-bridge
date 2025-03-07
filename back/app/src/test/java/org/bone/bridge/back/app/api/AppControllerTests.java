package org.bone.bridge.back.app.api;

import org.bone.bridge.back.app.config.Security;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.organizations.service.OrganizationService;
import org.bone.bridge.back.organizations.service.UserService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(AppController.class)
@ContextConfiguration(classes = AppController.class)
@Import(Security.class)
public class AppControllerTests {
    @Autowired
    MockMvc mockMvc;

    @MockitoBean
    UserService userService;

    @MockitoBean
    OrganizationService organizationService;

    @Test
    void helloShouldReturnOk() throws Exception {
        mockMvc
            .perform(get(Constants.HELLO_PATH))
            .andExpect(status().isOk());
    }
}
