package org.bone.bridge.back.countries.service;

import jakarta.validation.ConstraintViolationException;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.countries.model.ecu.OrganizationEcuData;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CountryService {
    private final OrganizationEcuService organizationEcuService;

    @NonNull
    public Object saveOrganization(@NonNull Country country, @NonNull Object data) throws ConstraintViolationException {
        if (Country.ECU.equals(country) && data instanceof OrganizationEcuData ecuData) {
            return organizationEcuService.save(ecuData);
        }
        throw new ConstraintViolationException("error.invalidData", Set.of());
    }
}
