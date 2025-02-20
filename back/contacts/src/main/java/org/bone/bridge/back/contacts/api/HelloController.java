package org.bone.bridge.back.contacts.api;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.Constants;
import org.springframework.boot.info.BuildProperties;
import org.springframework.http.HttpStatus;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(Constants.CONTACTS_PATH)
@RequiredArgsConstructor
public class HelloController {
    @Nullable
    private final BuildProperties buildProperties;

    @GetMapping(Constants.HELLO_PATH)
    @ResponseStatus(HttpStatus.OK)
    public String hello() {
        var version = buildProperties != null ? buildProperties.getVersion() : "-";
        return "Bone Bridge Contacts API v" + version;
    }
}
