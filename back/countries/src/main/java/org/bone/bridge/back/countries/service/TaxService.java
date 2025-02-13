package org.bone.bridge.back.countries.service;

import java.math.BigDecimal;
import java.util.Map;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.countries.model.Country;
import org.springframework.lang.NonNull;

public interface TaxService {
    boolean canHandle(@NonNull Country country);

    boolean taxesAreNotValid(@NonNull Map<TaxType, BigDecimal> taxes);
}
