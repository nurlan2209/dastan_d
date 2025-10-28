package com.photostudio.config;

import com.photostudio.model.User;
import com.photostudio.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
public class DataInitializer {

    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);

    @Bean
    public CommandLineRunner initDatabase(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        return args -> {
            // Create admin user if not exists
            if (!userRepository.existsByEmail("admin@photostudio.com")) {
                User admin = new User();
                admin.setName("Admin User");
                admin.setEmail("admin@photostudio.com");
                admin.setPassword(passwordEncoder.encode("admin123"));
                admin.setRole(User.UserRole.ADMIN);
                admin.setPhone("+1234567890");
                userRepository.save(admin);
                logger.info("✅ Admin user created: admin@photostudio.com / admin123");
            }

            // Create test client user if not exists
            if (!userRepository.existsByEmail("dastan@gmail.com")) {
                User client = new User();
                client.setName("Dastan");
                client.setEmail("dastan@gmail.com");
                client.setPassword(passwordEncoder.encode("1234"));
                client.setRole(User.UserRole.CLIENT);
                client.setPhone("+1234567891");
                userRepository.save(client);
                logger.info("✅ Test user created: dastan@gmail.com / 1234");
            }

            logger.info("🎉 Database initialization completed!");
        };
    }
}
