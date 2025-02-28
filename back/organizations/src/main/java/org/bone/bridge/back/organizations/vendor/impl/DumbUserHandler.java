package org.bone.bridge.back.organizations.vendor.impl;

import org.bone.bridge.back.organizations.model.User;
import org.bone.bridge.back.organizations.vendor.UserHandler;
import org.bone.bridge.back.utils.StringUtils;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

@Service
@ConditionalOnProperty(value = "user-handler", havingValue = "dumb", matchIfMissing = true)
public class DumbUserHandler implements UserHandler {
    @Override
    @Nullable
    public User userFromAuthToken(@NonNull String token) {
        if (StringUtils.isNotBlank(token)) {
            return User.builder()
                .uid(token)
                .email("dumb@mail.com")
                .name("Dumb")
                .build();
        }
        return null;
    }
}
