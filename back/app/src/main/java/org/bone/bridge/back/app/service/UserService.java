package org.bone.bridge.back.app.service;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.app.domain.UserConfig;
import org.bone.bridge.back.app.model.User;
import org.bone.bridge.back.app.repo.UserConfigRepo;
import org.bone.bridge.back.app.vendor.UserHandler;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserHandler userHandler;

    private final UserConfigRepo userConfigRepo;

    @Nullable
    public User userFromAuthToken(@NonNull String token) {
        return userHandler.userFromAuthToken(token);
    }

    public short userMaxOrganizations(@NonNull User user) {
        var userConfig = userConfig(user);
        return userConfig.getMaxOrganizations();
    }

    @NonNull
    private UserConfig userConfig(@NonNull User user) {
        return userConfigRepo
            .findByUserId(user.getUid())
            .orElseGet(() -> userConfigRepo.save(
                UserConfig.builder()
                    .userId(user.getUid())
                    .maxOrganizations((short) 1)
                    .build()));
    }
}
