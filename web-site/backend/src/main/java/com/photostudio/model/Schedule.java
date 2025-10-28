package com.photostudio.model;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalDateTime;

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

    // Constructors
    public Schedule() {
    }

    public Schedule(String id, User photographer, LocalDate date, String startTime,
                    String endTime, Boolean available, LocalDateTime createdAt) {
        this.id = id;
        this.photographer = photographer;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.available = available;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public User getPhotographer() {
        return photographer;
    }

    public void setPhotographer(User photographer) {
        this.photographer = photographer;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public Boolean getAvailable() {
        return available;
    }

    public void setAvailable(Boolean available) {
        this.available = available;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
