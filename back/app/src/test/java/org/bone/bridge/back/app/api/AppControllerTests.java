package org.bone.bridge.back.app.api;

import org.bone.bridge.back.app.config.Security;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(AppController.class)
@Import(Security.class)
public class AppControllerTests {
    @Autowired
    private MockMvc mockMvc;

    @Test
    public void helloShouldReturnOk() throws Exception {
        mockMvc
            .perform(get("/api/hello"))
            .andExpect(status().isOk());
    }
}
