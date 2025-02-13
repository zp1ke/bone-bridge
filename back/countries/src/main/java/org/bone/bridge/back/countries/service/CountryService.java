package org.bone.bridge.back.countries.service;

import jakarta.validation.ConstraintViolationException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.countries.model.OrganizationData;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CountryService {
    private final List<OrganizationService<? extends OrganizationData>> organizationServices;

    private final List<TaxService> taxServices;

    @NonNull
    public OrganizationData saveOrganization(@NonNull String code,
                                             @NonNull OrganizationData data) throws ConstraintViolationException {
        for (var organizationService : organizationServices) {
            if (organizationService.canHandle(data)) {
                return organizationService.save(code, data);
            }
        }
        throw new ConstraintViolationException("error.invalidData", Set.of());
    }

    public boolean taxesAreNotValid(@NonNull Country country,
                                    @NonNull Map<TaxType, BigDecimal> taxes) {
        for (var taxService : taxServices) {
            if (taxService.canHandle(country)) {
                return taxService.taxesAreNotValid(taxes);
            }
        }
        return false;
    }
}
