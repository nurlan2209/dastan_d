package com.photostudio.repository;

import com.photostudio.model.Order;
import com.photostudio.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface OrderRepository extends MongoRepository<Order, String> {

    List<Order> findByClient(User client);

    List<Order> findByPhotographer(User photographer);

    List<Order> findByStatus(Order.OrderStatus status);

    List<Order> findByCreatedAtBetween(LocalDateTime start, LocalDateTime end);

    Long countByStatus(Order.OrderStatus status);

    Long countByPhotographer(User photographer);

    @Query("{ 'createdAt': { $gte: ?0 } }")
    List<Order> findOrdersAfterDate(LocalDateTime date);
}
