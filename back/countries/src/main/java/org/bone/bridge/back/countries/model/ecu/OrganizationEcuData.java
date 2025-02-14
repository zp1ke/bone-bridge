package org.bone.bridge.back.countries.model.ecu;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.countries.domain.OrganizationEcu;
import org.bone.bridge.back.countries.model.OrganizationData;
import org.springframework.lang.NonNull;

@Getter
@Setter
@SuperBuilder
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class OrganizationEcuData extends OrganizationData {
    @Size(min = 3, max = 50)
    private String legalId;

    @NotNull
    private LegalIdType legalIdType;

    @NonNull
    public static OrganizationEcuData from(@NonNull OrganizationEcu organization) {
        return OrganizationEcuData.builder()
            .name(organization.getName())
            .email(organization.getEmail())
            .legalId(organization.getLegalId())
            .legalIdType(organization.getLegalIdType())
            .phone(organization.getPhone())
            .address(organization.getAddress())
            .build();
    }
}
