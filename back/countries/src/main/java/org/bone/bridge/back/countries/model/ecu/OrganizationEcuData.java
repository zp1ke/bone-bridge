package org.bone.bridge.back.countries.model.ecu;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.Objects;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.bone.bridge.back.countries.domain.OrganizationEcu;
import org.springframework.lang.NonNull;

@Getter
@Setter
@Builder
public class OrganizationEcuData {
    @Size(min = 3, max = 50)
    private String organizationCode;

    @Size(min = 3, max = 255)
    private String name;

    @Email
    @Size(min = 3, max = 255)
    private String email;

    @Size(min = 3, max = 50)
    private String legalId;

    @NotNull
    private LegalIdType legalIdType;

    @Size(max = 100)
    private String phone;

    @Size(max = 500)
    private String address;

    @NonNull
    public static OrganizationEcuData from(@NonNull OrganizationEcu organization) {
        return OrganizationEcuData.builder()
            .organizationCode(organization.getOrganizationCode())
            .name(organization.getName())
            .email(organization.getEmail())
            .legalId(organization.getLegalId())
            .legalIdType(organization.getLegalIdType())
            .phone(organization.getPhone())
            .address(organization.getAddress())
            .build();
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        OrganizationEcuData that = (OrganizationEcuData) o;
        return Objects.equals(organizationCode, that.organizationCode) &&
            Objects.equals(name, that.name) &&
            Objects.equals(email, that.email) &&
            Objects.equals(legalId, that.legalId) &&
            legalIdType == that.legalIdType &&
            Objects.equals(phone, that.phone) &&
            Objects.equals(address, that.address);
    }

    @Override
    public int hashCode() {
        return Objects.hash(organizationCode, name, email, legalId, legalIdType, phone, address);
    }
}
