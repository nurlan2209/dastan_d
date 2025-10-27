package com.photostudio.repository;

import com.photostudio.model.Review;
import com.photostudio.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends MongoRepository<Review, String> {

    List<Review> findByPhotographer(User photographer);

    List<Review> findByClient(User client);

    Long countByPhotographer(User photographer);
}
