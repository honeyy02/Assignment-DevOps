package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;

@SpringBootApplication
@RestController
public class DemoApplication {

    @GetMapping("/actuator/health")
    public String health() {
        return "UP";
    }

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}