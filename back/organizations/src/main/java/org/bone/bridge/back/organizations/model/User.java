package org.bone.bridge.back.organizations.model;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class User {
    private final String uid;

    private final String name;

    private final String email;
}
