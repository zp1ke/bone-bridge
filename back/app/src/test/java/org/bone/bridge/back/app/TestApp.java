package org.bone.bridge.back.app;

import org.springframework.boot.SpringApplication;

public class TestApp {
    public static void main(String[] args) {
        SpringApplication.from(App::main).with(TestcontainersConfig.class).run(args);
    }
}
