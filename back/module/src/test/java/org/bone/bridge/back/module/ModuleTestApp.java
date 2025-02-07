package org.bone.bridge.back.module;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ModuleTestApp {
    public static void main(String[] args) {
        SpringApplication.from(ModuleTestApp::main).with(TestcontainersConfig.class).run(args);
    }
}
