package com.photostudio.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "orders")
public class Order {

    @Id
    private String id;

    @DBRef
    @NotNull(message = "Клиент обязателен")
    private User client;

    @DBRef
    private User photographer;

    @NotBlank(message = "Услуга обязательна")
    private String service;

    @NotNull(message = "Дата съемки обязательна")
    private LocalDateTime date;

    private String location;

    @NotNull(message = "Статус обязателен")
    private OrderStatus status = OrderStatus.NEW;

    @NotNull(message = "Цена обязательна")
    private Double price;

    private String result; // Ссылка на Cloudinary

    private String comment;

    @CreatedDate
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    public enum OrderStatus {
        NEW,
        ASSIGNED,
        IN_PROGRESS,
        COMPLETED,
        CANCELLED,
        ARCHIVED
    }
}
