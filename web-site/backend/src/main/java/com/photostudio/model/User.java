package com.photostudio.model;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

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
    private String role;

    private String phone;

    private Double rating = 0.0;

    private Integer reviewsCount = 0;

    @CreatedDate
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    public enum UserRole {
        CLIENT("client"),
        PHOTOGRAPHER("photographer"),
        ADMIN("admin");

        private final String value;

        UserRole(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }

        public static UserRole fromValue(String value) {
            for (UserRole role : UserRole.values()) {
                if (role.value.equalsIgnoreCase(value)) {
                    return role;
                }
            }
            throw new IllegalArgumentException("Unknown role: " + value);
        }
    }

    // Constructors
    public User() {
    }

    public User(String id, String name, String email, String password, String role,
                String phone, Double rating, Integer reviewsCount, LocalDateTime createdAt,
                LocalDateTime updatedAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.phone = phone;
        this.rating = rating;
        this.reviewsCount = reviewsCount;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public UserRole getRoleEnum() {
        return UserRole.fromValue(this.role);
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Double getRating() {
        return rating;
    }

    public void setRating(Double rating) {
        this.rating = rating;
    }

    public Integer getReviewsCount() {
        return reviewsCount;
    }

    public void setReviewsCount(Integer reviewsCount) {
        this.reviewsCount = reviewsCount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
