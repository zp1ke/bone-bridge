package org.bone.bridge.back.organizations.model.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Getter;
import org.bone.bridge.back.organizations.domain.Organization;
import org.bone.bridge.back.countries.model.OrganizationData;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;

@Getter
@Builder
public class OrganizationDto {
    private final String code;

    @Size(min = 3, max = 255)
    private final String name;

    private final OrganizationData countryData;

    @Email
    @Size(min = 3, max = 255)
    private String email;

    @Size(max = 100)
    private String phone;

    @Size(max = 500)
    private String address;

    @NonNull
    public static OrganizationDto from(@NonNull Organization organization) {
        return from(organization, null);
    }

    @NonNull
    public static OrganizationDto from(@NonNull Organization organization,
                                       @Nullable OrganizationData countryData) {
        return OrganizationDto.builder()
            .code(organization.getCode())
            .name(organization.getName())
            .email(organization.getEmail())
            .phone(organization.getPhone())
            .address(organization.getAddress())
            .countryData(countryData)
            .build();
    }
}
