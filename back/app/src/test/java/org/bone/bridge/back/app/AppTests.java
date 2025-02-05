package org.bone.bridge.back.app;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfig.class)
@SpringBootTest
class AppTests {
    @Test
    void contextLoads() {
    }
}
