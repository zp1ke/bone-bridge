package org.bone.bridge.back.sales;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfig.class)
@SpringBootTest
class SalesAppTests {
    @Test
    void contextLoads() {
    }
}
