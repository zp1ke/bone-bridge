package org.bone.bridge.back.countries.repo;

import java.math.BigDecimal;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.countries.domain.TaxEcu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface TaxEcuRepo extends JpaRepository<TaxEcu, Long>, JpaSpecificationExecutor<TaxEcu> {
    boolean existsByTaxTypeAndPercentageAndEnabled(TaxType taxType, BigDecimal percentage, boolean enabled);
}
