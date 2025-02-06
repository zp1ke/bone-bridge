package org.bone.bridge.back.config;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ProductsTestApp {
    public static void main(String[] args) {
        SpringApplication.from(ProductsTestApp::main).with(TestcontainersConfig.class).run(args);
    }
}
