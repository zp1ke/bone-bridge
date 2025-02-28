package org.bone.bridge.back.organizations.model;

import lombok.Builder;
import lombok.Getter;
import org.bone.bridge.back.organizations.domain.Organization;

@Getter
@Builder
public class UserAuth {
    private final String token;

    private final User user;

    private final Organization organization;
}
