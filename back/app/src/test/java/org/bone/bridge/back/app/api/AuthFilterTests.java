package org.bone.bridge.back.app.api;

import java.util.List;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

public class AuthFilterTests {
    @Test
    public void organizationCodeFromPath_whenPathIsOrganizationsCode_returnsCode() {
        var code = "123";
        var paths = List.of(
            "/organizations/" + code,
            "/organizations/" + code + "/",
            "/organizations/" + code + "/members",
            "api/organizations/" + code,
            "/api/organizations/" + code,
            "/api/organizations/" + code + "/",
            "/api/organizations/" + code + "/members"
        );
        for (var path : paths) {
            var result = AuthFilter.organizationCodeFromPath(path);
            assertEquals(code, result);
        }
    }

    @Test
    public void organizationCodeFromPath_whenPathIsNotOrganizationsCode_returnsNull() {
        var paths = List.of(
            "/organizations",
            "/organizations/",
            "other/organizations/",
            "/other/organizations/",
            "/members/nothing/here"
        );
        for (var path : paths) {
            var result = AuthFilter.organizationCodeFromPath(path);
            assertNull(result);
        }
    }
}
