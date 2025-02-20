package org.bone.bridge.back.sales;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SalesTestApp {
    public static void main(String[] args) {
        SpringApplication.from(SalesTestApp::main).with(TestcontainersConfig.class).run(args);
    }
}
