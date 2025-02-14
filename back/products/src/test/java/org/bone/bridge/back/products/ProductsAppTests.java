package org.bone.bridge.back.products;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfig.class)
@SpringBootTest
class ProductsAppTests {
    @Test
    void contextLoads() {
    }
}
