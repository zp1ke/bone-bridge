package org.bone.bridge.back.organizations;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(scanBasePackages = "org.bone.bridge.back")
@EntityScan(basePackages = "org.bone.bridge.back")
@EnableJpaRepositories(basePackages = "org.bone.bridge.back")
public class OrganizationsTestApp {
    public static void main(String[] args) {
        SpringApplication.from(OrganizationsTestApp::main).with(TestcontainersConfig.class).run(args);
    }
}
