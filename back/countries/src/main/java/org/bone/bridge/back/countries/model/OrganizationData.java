package org.bone.bridge.back.countries.model;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import java.util.Objects;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.countries.model.ecu.OrganizationEcuData;

@Getter
@Setter
@SuperBuilder
@JsonTypeInfo(
    use = JsonTypeInfo.Id.NAME,
    include = JsonTypeInfo.As.PROPERTY,
    property = "country")
@JsonSubTypes({
    @JsonSubTypes.Type(value = OrganizationEcuData.class, name = "ECU")
})
@NoArgsConstructor
public abstract class OrganizationData {
    @Size(min = 3, max = 255)
    private String name;

    @Email
    @Size(min = 3, max = 255)
    private String email;

    @Size(max = 100)
    private String phone;

    @Size(max = 500)
    private String address;

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        OrganizationData that = (OrganizationData) o;
        return Objects.equals(name, that.name) &&
            Objects.equals(email, that.email) &&
            Objects.equals(phone, that.phone) &&
            Objects.equals(address, that.address);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, email, phone, address);
    }
}
