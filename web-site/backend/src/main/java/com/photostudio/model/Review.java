package com.photostudio.model;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import jakarta.validation.constraints.*;
import java.time.LocalDateTime;

@Document(collection = "reviews")
public class Review {

    @Id
    private String id;

    @DBRef
    @NotNull(message = "Заказ обязателен")
    private Order order;

    @DBRef
    @NotNull(message = "Клиент обязателен")
    private User client;

    @DBRef
    @NotNull(message = "Фотограф обязателен")
    private User photographer;

    @NotNull(message = "Рейтинг обязателен")
    @Min(value = 1, message = "Минимальный рейтинг 1")
    @Max(value = 5, message = "Максимальный рейтинг 5")
    private Integer rating;

    private String comment;

    @CreatedDate
    private LocalDateTime createdAt;

    // Constructors
    public Review() {
    }

    public Review(String id, Order order, User client, User photographer, Integer rating,
                  String comment, LocalDateTime createdAt) {
        this.id = id;
        this.order = order;
        this.client = client;
        this.photographer = photographer;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public User getClient() {
        return client;
    }

    public void setClient(User client) {
        this.client = client;
    }

    public User getPhotographer() {
        return photographer;
    }

    public void setPhotographer(User photographer) {
        this.photographer = photographer;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
