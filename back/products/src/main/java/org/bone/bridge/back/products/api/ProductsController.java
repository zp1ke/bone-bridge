package org.bone.bridge.back.products.api;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.error.InvalidDataException;
import org.bone.bridge.back.products.domain.Product;
import org.bone.bridge.back.products.model.dto.ProductDto;
import org.bone.bridge.back.products.service.ProductService;
import org.springframework.boot.info.BuildProperties;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping(Constants.PRODUCTS_PATH)
@RequiredArgsConstructor
public class ProductsController {
    @Nullable
    private final BuildProperties buildProperties;

    private final ProductService productService;

    @GetMapping(Constants.HELLO_PATH)
    @ResponseStatus(HttpStatus.OK)
    public String hello() {
        var version = buildProperties != null ? buildProperties.getVersion() : "-";
        return "Bone Bridge Products API v" + version;
    }

    @PostMapping(Constants.ORGANIZATIONS_PATH + "/{organizationCode}")
    public ResponseEntity<ProductDto> create(@PathVariable String organizationCode,
                                             @Valid @RequestBody ProductDto request) {
        try {
            var product = Product.builder()
                .code(request.getCode())
                .name(request.getName())
                .unitPrice(request.getUnitPrice())
                .build();

            product = productService.create(organizationCode, product);
            return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ProductDto.from(product));
        } catch (InvalidDataException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }
}
