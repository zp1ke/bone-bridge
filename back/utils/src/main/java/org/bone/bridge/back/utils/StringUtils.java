package org.bone.bridge.back.utils;

import org.bone.bridge.back.utils.model.StringConfig;

public class StringUtils {
    public static boolean isBlank(String value) {
        return value == null || value.trim().isBlank();
    }

    public static boolean isNotBlank(String value) {
        return value != null && !value.trim().isBlank();
    }

    public static String randomString(StringConfig config) {
        var builder = new StringBuilder();
        if (config.getLowercaseLetters() > 0) {
            builder.append(randomString(config.getLowercaseLetters(), 'a', 'z'));
        }
        if (config.getNumbers() > 0) {
            builder.append(randomString(config.getNumbers(), '0', '9'));
        }
        return builder.toString();
    }

    private static String randomString(int length, char from, char to) {
        var builder = new StringBuilder();
        for (int i = 0; i < length; i++) {
            builder.append((char) (from + Math.random() * (to - from + 1)));
        }
        return builder.toString();
    }
}
