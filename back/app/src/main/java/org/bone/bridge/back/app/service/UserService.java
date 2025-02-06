package org.bone.bridge.back.app.service;

import org.bone.bridge.back.app.model.User;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;

public interface UserService {
    @Nullable
    User userFromAuthToken(@NonNull String token);
}
