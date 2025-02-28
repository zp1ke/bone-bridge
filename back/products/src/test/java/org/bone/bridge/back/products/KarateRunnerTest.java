package org.bone.bridge.back.products;

import com.intuit.karate.junit5.Karate;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfig.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class KarateRunnerTest {
    @LocalServerPort
    String serverPort;

    @Karate.Test
    Karate testFeatures() {
        return Karate
            .run("classpath:features/")
            .relativeTo(getClass())
            .systemProperty("baseUrl", "http://localhost:" + serverPort);
    }
}
