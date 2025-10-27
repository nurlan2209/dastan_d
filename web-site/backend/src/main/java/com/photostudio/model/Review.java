package com.photostudio.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import jakarta.validation.constraints.*;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
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
}
