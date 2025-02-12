package org.bone.bridge.back.countries.service;

import jakarta.validation.ConstraintViolationException;
import java.math.BigDecimal;
import java.util.Map;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.countries.model.OrganizationData;
import org.bone.bridge.back.countries.model.ecu.OrganizationEcuData;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CountryService {
    private final OrganizationEcuService organizationEcuService;

    @NonNull
    public OrganizationData saveOrganization(@NonNull String code,
                                             @NonNull OrganizationData data) throws ConstraintViolationException {
        if (data instanceof OrganizationEcuData ecuData) {
            return organizationEcuService.save(code, ecuData);
        }
        throw new ConstraintViolationException("error.invalidData", Set.of());
    }

    public boolean taxesAreNotValid(@NonNull Country country,
                                    @NonNull Map<TaxType, BigDecimal> taxes) {
        // TODO
        return false;
    }
}
