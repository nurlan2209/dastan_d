package com.photostudio.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "schedules")
public class Schedule {

    @Id
    private String id;

    @DBRef
    @NotNull(message = "Фотограф обязателен")
    private User photographer;

    @NotNull(message = "Дата обязательна")
    private LocalDate date;

    @NotBlank(message = "Время начала обязательно")
    private String startTime;

    @NotBlank(message = "Время окончания обязательно")
    private String endTime;

    @NotNull(message = "Доступность обязательна")
    private Boolean available = true;

    @CreatedDate
    private LocalDateTime createdAt;
}
