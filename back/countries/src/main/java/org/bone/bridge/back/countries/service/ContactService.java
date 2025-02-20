package org.bone.bridge.back.countries.service;

import jakarta.validation.ConstraintViolationException;
import org.bone.bridge.back.countries.model.ContactData;
import org.springframework.lang.NonNull;

public interface ContactService<T extends ContactData> {
    @NonNull
    T save(@NonNull String contactCode,
           @NonNull ContactData data) throws ConstraintViolationException;

    Class<T> getDataClass();

    default boolean canHandle(@NonNull ContactData data) {
        return data.getClass().equals(getDataClass());
    }
}
