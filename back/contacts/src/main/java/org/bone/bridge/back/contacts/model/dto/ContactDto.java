package org.bone.bridge.back.contacts.model.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Getter;
import org.bone.bridge.back.contacts.domain.Contact;
import org.springframework.lang.NonNull;

@Getter
@Builder
public class ContactDto {
    private final String code;

    @Size(min = 3, max = 255)
    private String name;

    @Email
    @Size(min = 3, max = 255)
    private String email;

    @NonNull
    public static ContactDto from(@NonNull Contact contact) {
        return ContactDto.builder()
            .code(contact.getCode())
            .name(contact.getName())
            .email(contact.getEmail())
            .build();
    }
}
