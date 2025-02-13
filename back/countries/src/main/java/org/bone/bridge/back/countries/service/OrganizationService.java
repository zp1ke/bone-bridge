package org.bone.bridge.back.countries.service;

import jakarta.validation.ConstraintViolationException;
import org.bone.bridge.back.countries.model.OrganizationData;
import org.springframework.lang.NonNull;

public interface OrganizationService<T extends OrganizationData> {
    @NonNull
    T save(@NonNull String organizationCode,
           @NonNull OrganizationData data) throws ConstraintViolationException;

    Class<T> getDataClass();

    default boolean canHandle(@NonNull OrganizationData data) {
        return data.getClass().equals(getDataClass());
    }
}
