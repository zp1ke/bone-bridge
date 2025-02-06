package org.bone.bridge.back.config;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfig.class)
@SpringBootTest
class ConfigAppTests {
    @Test
    void contextLoads() {
    }
}
