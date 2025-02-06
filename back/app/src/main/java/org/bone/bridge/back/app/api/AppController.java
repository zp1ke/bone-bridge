package org.bone.bridge.back.app.api;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.Constants;
import org.springframework.boot.info.BuildProperties;
import org.springframework.http.HttpStatus;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class AppController {
    @Nullable
    private final BuildProperties buildProperties;

    @GetMapping(Constants.HELLO_PATH)
    @ResponseStatus(HttpStatus.OK)
    public String hello() {
        var version = buildProperties != null ? buildProperties.getVersion() : "-";
        return "Bone Bridge API v" + version;
    }
}
