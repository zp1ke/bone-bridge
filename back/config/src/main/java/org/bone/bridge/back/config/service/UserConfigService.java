package org.bone.bridge.back.config.service;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.domain.UserConfig;
import org.bone.bridge.back.config.repo.UserConfigRepo;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserConfigService {
    private final UserConfigRepo userConfigRepo;

    public short userMaxOrganizations(@NonNull String userId) {
        var userConfig = userConfig(userId);
        return userConfig.getMaxOrganizations();
    }

    @NonNull
    private UserConfig userConfig(@NonNull String userId) {
        return userConfigRepo
            .findByUserId(userId)
            .orElseGet(() -> userConfigRepo.save(
                UserConfig.builder()
                    .userId(userId)
                    .maxOrganizations(Constants.USER_DEFAULT_MAX_ORGANIZATIONS)
                    .build()));
    }
}
