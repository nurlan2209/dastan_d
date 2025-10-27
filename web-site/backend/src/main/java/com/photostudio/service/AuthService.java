package com.photostudio.service;

import com.photostudio.dto.AuthResponse;
import com.photostudio.dto.LoginRequest;
import com.photostudio.dto.RegisterRequest;
import com.photostudio.model.User;
import com.photostudio.repository.UserRepository;
import com.photostudio.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final AuthenticationManager authenticationManager;

    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email уже используется");
        }

        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(request.getRole() != null ? request.getRole() : User.UserRole.CLIENT);
        user.setPhone(request.getPhone());

        User savedUser = userRepository.save(user);

        String accessToken = jwtTokenProvider.generateAccessToken(savedUser.getId(), savedUser.getRole().name());
        String refreshToken = jwtTokenProvider.generateRefreshToken(savedUser.getId());

        return new AuthResponse(
                accessToken,
                refreshToken,
                savedUser.getId(),
                savedUser.getRole(),
                savedUser.getName(),
                savedUser.getEmail()
        );
    }

    public AuthResponse login(LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));

        String accessToken = jwtTokenProvider.generateAccessToken(user.getId(), user.getRole().name());
        String refreshToken = jwtTokenProvider.generateRefreshToken(user.getId());

        return new AuthResponse(
                accessToken,
                refreshToken,
                user.getId(),
                user.getRole(),
                user.getName(),
                user.getEmail()
        );
    }

    public AuthResponse refreshToken(String refreshToken) {
        if (!jwtTokenProvider.validateToken(refreshToken)) {
            throw new RuntimeException("Invalid refresh token");
        }

        String userId = jwtTokenProvider.getUserIdFromToken(refreshToken);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));

        String newAccessToken = jwtTokenProvider.generateAccessToken(user.getId(), user.getRole().name());

        return new AuthResponse(
                newAccessToken,
                refreshToken,
                user.getId(),
                user.getRole(),
                user.getName(),
                user.getEmail()
        );
    }
}
