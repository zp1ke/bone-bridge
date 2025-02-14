package org.bone.bridge.back.products.api;

import java.math.BigDecimal;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.products.TestcontainersConfig;
import org.bone.bridge.back.products.model.dto.ProductDto;
import org.bone.bridge.back.products.repo.ProductRepo;
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
public class ProductControllerIntegrationTests {
    @Autowired
    TestRestTemplate testRestTemplate;

    @Autowired
    ProductRepo productRepo;

    @Test
    void testCreateProduct_WithoutTaxes() {
        var organizationCode = "org-1";
        var dto = ProductDto.builder()
            .code("product-1")
            .name("Product 1")
            .unitPrice(BigDecimal.TEN)
            .build();

        var url = String.format("%s/%s%s", Constants.ORGANIZATIONS_PATH, organizationCode, Constants.PRODUCTS_PATH);
        var response = testRestTemplate.postForEntity(url, dto, ProductDto.class);

        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(dto.getCode(), response.getBody().getCode());
        assertEquals(dto.getName(), response.getBody().getName());
        assertBigDecimalEquals(dto.getUnitPrice(), response.getBody().getUnitPrice());

        var product = productRepo.findOneByOrganizationCodeAndCode(organizationCode, dto.getCode());
        assertTrue(product.isPresent());
        assertEquals(dto.getCode(), product.get().getCode());
        assertEquals(dto.getName(), product.get().getName());
        assertBigDecimalEquals(dto.getUnitPrice(), product.get().getUnitPrice());
    }
}
