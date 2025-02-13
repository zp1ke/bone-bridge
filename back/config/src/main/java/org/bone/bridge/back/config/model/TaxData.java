package org.bone.bridge.back.config.model;

import java.math.BigDecimal;

public interface TaxData {
    String getCountryCode();

    String getName();

    TaxType getTaxType();

    BigDecimal getPercentage();

    boolean isEnabled();
}
