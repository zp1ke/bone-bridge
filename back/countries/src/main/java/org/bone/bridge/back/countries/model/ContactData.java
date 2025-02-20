package org.bone.bridge.back.countries.model;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.countries.model.ecu.ContactEcuData;

@Getter
@Setter
@SuperBuilder
@JsonTypeInfo(
    use = JsonTypeInfo.Id.NAME,
    include = JsonTypeInfo.As.PROPERTY,
    property = "country")
@JsonSubTypes({
    @JsonSubTypes.Type(value = ContactEcuData.class, name = "ECU")
})
@NoArgsConstructor
@EqualsAndHashCode
public abstract class ContactData {
    @Size(min = 3, max = 255)
    private String name;

    @Email
    @Size(min = 3, max = 255)
    private String email;

    @Size(max = 100)
    private String phone;

    @Size(max = 500)
    private String address;
}
