package org.bone.bridge.back.contacts.model.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Getter;
import org.bone.bridge.back.contacts.domain.Contact;
import org.bone.bridge.back.countries.model.ContactData;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;

@Getter
@Builder
public class ContactDto {
    private final String code;

    private final ContactData countryData;

    @Size(min = 3, max = 255)
    private String name;

    @Email
    @Size(min = 3, max = 255)
    private String email;

    @NonNull
    public static ContactDto from(@NonNull Contact contact) {
        return from(contact, null);
    }

    @NonNull
    public static ContactDto from(@NonNull Contact contact,
                                  @Nullable ContactData countryData) {
        return ContactDto.builder()
            .code(contact.getCode())
            .name(contact.getName())
            .email(contact.getEmail())
            .countryData(countryData)
            .build();
    }
}
