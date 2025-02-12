package org.bone.bridge.back.config.model;

public enum TaxType {
    EXCISE(true),
    VAT(false),
    REDEEMABLE(false);

    private final boolean affectsSubtotal;

    TaxType(boolean affectsSubtotal) {
        this.affectsSubtotal = affectsSubtotal;
    }

    public boolean affectsSubtotal() {
        return affectsSubtotal;
    }
}
