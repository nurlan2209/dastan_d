package com.photostudio;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.config.EnableMongoAuditing;

@SpringBootApplication
@EnableMongoAuditing
public class PhotoStudioApplication {

    public static void main(String[] args) {
        SpringApplication.run(PhotoStudioApplication.class, args);
        System.out.println("\n🚀 Photo Studio Backend is running on http://localhost:8080");
        System.out.println("📚 API Documentation: http://localhost:8080/api");
        System.out.println("🏥 Health Check: http://localhost:8080/actuator/health\n");
    }
}
