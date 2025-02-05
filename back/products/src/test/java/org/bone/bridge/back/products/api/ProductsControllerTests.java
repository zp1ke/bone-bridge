package org.bone.bridge.back.products.api;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ProductsController.class)
public class ProductsControllerTests {
    @Autowired
    private MockMvc mockMvc;

    @Test
    public void helloShouldReturnOk() throws Exception {
        mockMvc
            .perform(get("/api/products/hello"))
            .andExpect(status().isOk());
    }
}
