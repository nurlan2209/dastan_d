package com.photostudio.dto;

import com.photostudio.model.User;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AuthResponse {
    private String accessToken;
    private String refreshToken;
    private String userId;
    private User.UserRole role;
    private String name;
    private String email;
}
