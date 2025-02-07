package org.bone.bridge.back.app.dto;

import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Getter;
import org.bone.bridge.back.app.domain.Organization;
import org.springframework.lang.NonNull;

@Getter
@Builder
public class OrganizationDto {
    private final String code;

    @Size(min = 3, max = 255)
    private final String name;

    @NonNull
    public static OrganizationDto from(@NonNull Organization organization) {
        return OrganizationDto.builder()
            .code(organization.getCode())
            .name(organization.getName())
            .build();
    }
}
