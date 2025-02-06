package org.bone.bridge.back.app.model;

import lombok.Builder;
import lombok.Getter;
import org.bone.bridge.back.app.domain.Organization;

@Getter
@Builder
public class UserAuth {
    private final String token;

    private final User user;

    private final Organization organization;
}
