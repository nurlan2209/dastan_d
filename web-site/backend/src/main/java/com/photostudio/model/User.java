package com.photostudio.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "users")
public class User {

    @Id
    private String id;

    @NotBlank(message = "Имя обязательно")
    private String name;

    @Email(message = "Некорректный формат email")
    @NotBlank(message = "Email обязателен")
    @Indexed(unique = true)
    private String email;

    @NotBlank(message = "Пароль обязателен")
    private String password;

    @NotNull(message = "Роль обязательна")
    private UserRole role;

    private String phone;

    private Double rating = 0.0;

    private Integer reviewsCount = 0;

    @CreatedDate
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    public enum UserRole {
        CLIENT,
        PHOTOGRAPHER,
        ADMIN
    }
}
