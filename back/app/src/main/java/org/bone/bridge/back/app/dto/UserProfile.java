package org.bone.bridge.back.app.dto;

import java.util.List;
import lombok.Builder;

@Builder
public class UserProfile {
    private final String name;

    private final String email;

    private final short maxOrganizations;

    private final List<OrganizationDto> organizations;
}
