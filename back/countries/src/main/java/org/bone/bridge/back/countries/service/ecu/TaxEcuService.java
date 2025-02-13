package org.bone.bridge.back.countries.service.ecu;

import java.math.BigDecimal;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.countries.repo.TaxEcuRepo;
import org.bone.bridge.back.countries.service.TaxService;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TaxEcuService implements TaxService {
    private final TaxEcuRepo taxEcuRepo;

    @Override
    public boolean canHandle(@NonNull Country country) {
        return Country.ECU.equals(country);
    }

    @Override
    public boolean taxesAreNotValid(@NonNull Map<TaxType, BigDecimal> taxes) {
        for (var tax : taxes.entrySet()) {
            var exists = taxEcuRepo.existsByTaxTypeAndPercentageAndEnabled(tax.getKey(), tax.getValue(), true);
            if (!exists) {
                return true;
            }
        }
        return false;
    }
}
