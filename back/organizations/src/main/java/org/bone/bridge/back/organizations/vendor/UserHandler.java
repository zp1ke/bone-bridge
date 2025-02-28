package org.bone.bridge.back.organizations.vendor;

import org.bone.bridge.back.organizations.model.User;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;

public interface UserHandler {
    @Nullable
    User userFromAuthToken(@NonNull String token);
}
