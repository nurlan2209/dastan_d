package com.photostudio.repository;

import com.photostudio.model.Schedule;
import com.photostudio.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ScheduleRepository extends MongoRepository<Schedule, String> {

    List<Schedule> findByPhotographer(User photographer);

    List<Schedule> findByPhotographerAndDateBetween(User photographer, LocalDate start, LocalDate end);

    Optional<Schedule> findByPhotographerAndDate(User photographer, LocalDate date);

    List<Schedule> findByAvailableTrue();
}
