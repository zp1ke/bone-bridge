package org.bone.bridge.back.countries;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CountriesTestApp {
    public static void main(String[] args) {
        SpringApplication.from(CountriesTestApp::main).with(TestcontainersConfig.class).run(args);
    }
}
