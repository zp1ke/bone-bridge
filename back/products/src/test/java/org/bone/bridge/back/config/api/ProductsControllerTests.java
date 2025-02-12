package org.bone.bridge.back.config.api;

import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.products.api.ProductsController;
import org.bone.bridge.back.products.service.ProductService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ProductsController.class)
@ContextConfiguration(classes = ProductsController.class)
public class ProductsControllerTests {
    @MockitoBean
    ProductService productService;

    @Autowired
    private MockMvc mockMvc;

    @Test
    void helloShouldReturnOk() throws Exception {
        var url = Constants.PRODUCTS_PATH + Constants.HELLO_PATH;
        mockMvc
            .perform(get(url))
            .andExpect(status().isOk());
    }
}
