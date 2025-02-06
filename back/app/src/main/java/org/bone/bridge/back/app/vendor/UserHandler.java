package org.bone.bridge.back.app.vendor;

import org.bone.bridge.back.app.model.User;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;

public interface UserHandler {
    @Nullable
    User userFromAuthToken(@NonNull String token);
}
