package org.bone.bridge.back.utils.model;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public final class StringConfig {
    private final int lowercaseLetters;

    private final int numbers;
}
