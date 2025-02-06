package org.bone.bridge.back.utilities;

import java.util.List;
import org.bone.bridge.back.utilities.model.StringConfig;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class StringUtilsTests {
    @Test
    public void isBlank_ShouldReturnTrue_WhenValueIsNull() {
        assertTrue(StringUtils.isBlank(null));
    }

    @Test
    public void isBlank_ShouldReturnTrue_WhenValueIsEmpty() {
        assertTrue(StringUtils.isBlank(""));
    }

    @Test
    public void isBlank_ShouldReturnTrue_WhenValueIsBlank() {
        assertTrue(StringUtils.isBlank(" "));
    }

    @Test
    public void isBlank_ShouldReturnTrue_WhenValueIsOnlySpaces() {
        assertTrue(StringUtils.isBlank("   "));
    }

    @Test
    public void isBlank_ShouldReturnFalse_WhenValueIsNotEmpty() {
        assertFalse(StringUtils.isBlank("value"));
    }

    @Test
    public void isNotBlank_ShouldReturnFalse_WhenValueIsNull() {
        assertFalse(StringUtils.isNotBlank(null));
    }

    @Test
    public void isNotBlank_ShouldReturnFalse_WhenValueIsEmpty() {
        assertFalse(StringUtils.isNotBlank(""));
    }

    @Test
    public void isNotBlank_ShouldReturnFalse_WhenValueIsBlank() {
        assertFalse(StringUtils.isNotBlank(" "));
    }

    @Test
    public void isNotBlank_ShouldReturnFalse_WhenValueIsOnlySpaces() {
        assertFalse(StringUtils.isNotBlank("   "));
    }

    @Test
    public void isNotBlank_ShouldReturnTrue_WhenValueIsNotEmpty() {
        assertTrue(StringUtils.isNotBlank("value"));
    }

    @Test
    public void randomString_ShouldReturnStringWithLengthOfConfig() {
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
