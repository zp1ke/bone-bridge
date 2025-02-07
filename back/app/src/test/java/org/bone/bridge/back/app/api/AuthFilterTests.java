package org.bone.bridge.back.app.api;

import java.util.List;
import org.bone.bridge.back.config.Constants;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

public class AuthFilterTests {
    @Test
    void organizationCodeFromPath_whenPathIsOrganizationsCode_returnsCode() {
        var code = "123";
        var paths = List.of(
            Constants.ORGANIZATIONS_PATH + "/" + code,
            Constants.ORGANIZATIONS_PATH + "/" + code + "/",
            Constants.ORGANIZATIONS_PATH + "/" + code + "/members",
            "api" + Constants.ORGANIZATIONS_PATH + "/" + code,
            "/api" + Constants.ORGANIZATIONS_PATH + "/" + code,
            "/api" + Constants.ORGANIZATIONS_PATH + "/" + code + "/",
            "/api" + Constants.ORGANIZATIONS_PATH + "/" + code + "/members"
        );
        for (var path : paths) {
            var result = AuthFilter.organizationCodeFromPath(path);
            assertEquals(code, result);
        }
    }

    @Test
    void organizationCodeFromPath_whenPathIsNotOrganizationsCode_returnsNull() {
        var paths = List.of(
            Constants.ORGANIZATIONS_PATH,
            Constants.ORGANIZATIONS_PATH + "/",
            "other" + Constants.ORGANIZATIONS_PATH + "/",
            "/other" + Constants.ORGANIZATIONS_PATH + "/",
            "/members/nothing/here"
        );
        for (var path : paths) {
            var result = AuthFilter.organizationCodeFromPath(path);
            assertNull(result);
        }
    }
}
