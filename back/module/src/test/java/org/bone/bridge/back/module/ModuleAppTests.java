package org.bone.bridge.back.module;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfig.class)
@SpringBootTest
class ModuleAppTests {
    @Test
    void contextLoads() {
    }
}
