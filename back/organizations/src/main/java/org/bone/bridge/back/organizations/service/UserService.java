package org.bone.bridge.back.organizations.service;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.organizations.model.User;
import org.bone.bridge.back.organizations.vendor.UserHandler;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserHandler userHandler;

    @Nullable
    public User userFromAuthToken(@NonNull String token) {
        return userHandler.userFromAuthToken(token);
    }
}
