package org.bone.bridge.back.countries;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfig.class)
@SpringBootTest
class CountryAppTests {
    @Test
    void contextLoads() {
    }
}
