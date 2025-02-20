package org.bone.bridge.back.contacts;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(scanBasePackages = "org.bone.bridge.back")
@EntityScan(basePackages = "org.bone.bridge.back")
@EnableJpaRepositories(basePackages = "org.bone.bridge.back")
public class ContactsTestApp {
    public static void main(String[] args) {
        SpringApplication.from(ContactsTestApp::main).with(TestcontainersConfig.class).run(args);
    }
}
