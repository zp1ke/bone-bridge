package org.bone.bridge.back.products.api;

import jakarta.annotation.Nullable;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.Constants;
import org.springframework.boot.info.BuildProperties;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(Constants.PRODUCTS_PATH)
@RequiredArgsConstructor
public class ProductsController {
    @Nullable
    private final BuildProperties buildProperties;

    @GetMapping(Constants.HELLO_PATH)
    @ResponseStatus(HttpStatus.OK)
    public String hello() {
        var version = buildProperties != null ? buildProperties.getVersion() : "-";
        return "Bone Bridge Products API v" + version;
    }
}
