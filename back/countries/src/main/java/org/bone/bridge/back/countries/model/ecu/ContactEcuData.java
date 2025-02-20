package org.bone.bridge.back.countries.model.ecu;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.bone.bridge.back.countries.domain.ContactEcu;
import org.bone.bridge.back.countries.model.ContactData;
import org.springframework.lang.NonNull;

@Getter
@Setter
@SuperBuilder
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class ContactEcuData extends ContactData {
    @Size(min = 3, max = 50)
    private String legalId;

    @NotNull
    private LegalIdType legalIdType;

    @NonNull
    public static ContactEcuData from(@NonNull ContactEcu contact) {
        return ContactEcuData.builder()
            .name(contact.getName())
            .email(contact.getEmail())
            .legalId(contact.getLegalId())
            .legalIdType(contact.getLegalIdType())
            .phone(contact.getPhone())
            .address(contact.getAddress())
            .build();
    }
}
