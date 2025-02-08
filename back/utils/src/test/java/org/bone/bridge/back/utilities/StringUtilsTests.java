package org.bone.bridge.back.utilities;

import java.util.List;
import org.bone.bridge.back.utils.StringUtils;
import org.bone.bridge.back.utils.model.StringConfig;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class StringUtilsTests {
    @Test
    void isBlank_ShouldReturnTrue_WhenValueIsNull() {
        assertTrue(StringUtils.isBlank(null));
    }

    @Test
    void isBlank_ShouldReturnTrue_WhenValueIsEmpty() {
        assertTrue(StringUtils.isBlank(""));
    }

    @Test
    void isBlank_ShouldReturnTrue_WhenValueIsBlank() {
        assertTrue(StringUtils.isBlank(" "));
    }

    @Test
    void isBlank_ShouldReturnTrue_WhenValueIsOnlySpaces() {
        assertTrue(StringUtils.isBlank("   "));
    }

    @Test
    void isBlank_ShouldReturnFalse_WhenValueIsNotEmpty() {
        assertFalse(StringUtils.isBlank("value"));
    }

    @Test
    void isNotBlank_ShouldReturnFalse_WhenValueIsNull() {
        assertFalse(StringUtils.isNotBlank(null));
    }

    @Test
    void isNotBlank_ShouldReturnFalse_WhenValueIsEmpty() {
        assertFalse(StringUtils.isNotBlank(""));
    }

    @Test
    void isNotBlank_ShouldReturnFalse_WhenValueIsBlank() {
        assertFalse(StringUtils.isNotBlank(" "));
    }

    @Test
    void isNotBlank_ShouldReturnFalse_WhenValueIsOnlySpaces() {
        assertFalse(StringUtils.isNotBlank("   "));
    }

    @Test
    void isNotBlank_ShouldReturnTrue_WhenValueIsNotEmpty() {
        assertTrue(StringUtils.isNotBlank("value"));
    }

    @Test
    void randomString_ShouldReturnStringWithLengthOfConfig() {
        var lengths = List.of(1, 5, 10, 20);
        for (var length : lengths) {
            var config = StringConfig.builder()
                .lowercaseLetters(length)
                .numbers(length)
                .build();
            var result = StringUtils.randomString(config);
            assertNotNull(result);
            assertEquals(length * 2, result.length());
            assertTrue(result.matches(String.format("[a-z]{%d}[0-9]{%d}", length, length)));
        }
    }
}
