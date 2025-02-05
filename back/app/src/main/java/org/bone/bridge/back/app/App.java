package org.bone.bridge.back.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "org.bone.bridge.back")
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
}

