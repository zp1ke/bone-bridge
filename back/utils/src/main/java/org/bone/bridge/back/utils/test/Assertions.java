package org.bone.bridge.back.utils.test;

import java.math.BigDecimal;

public class Assertions {
    public static void assertBigDecimalEquals(BigDecimal expected, BigDecimal actual) {
        assertBigDecimalEquals(expected, actual, null);
    }

    public static void assertBigDecimalEquals(BigDecimal expected, BigDecimal actual, String message) {
        if (expected == null && actual == null) {
            return;
        }

        var msg = message != null ? message : "Expected: " + expected + ", but got: " + actual;

        if (expected == null || actual == null) {
            throw new AssertionError(msg);
        }

        if (expected.compareTo(actual) != 0) {
            throw new AssertionError(msg);
        }
    }
}
