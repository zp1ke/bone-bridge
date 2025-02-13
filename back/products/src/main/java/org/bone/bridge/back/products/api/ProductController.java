package org.bone.bridge.back.products.api;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.error.InvalidDataException;
import org.bone.bridge.back.products.domain.Product;
import org.bone.bridge.back.products.model.dto.ProductDto;
import org.bone.bridge.back.products.service.ProductService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping(Constants.ORGANIZATIONS_PATH + "/{organizationCode}" + Constants.PRODUCTS_PATH)
@RequiredArgsConstructor
public class ProductController {
    private final ProductService productService;

    @PostMapping
    public ResponseEntity<ProductDto> create(@PathVariable String organizationCode,
                                             @Valid @RequestBody ProductDto request) {
        try {
            var product = Product.builder()
                .code(request.getCode())
                .name(request.getName())
                .unitPrice(request.getUnitPrice())
                .build();

            var productAndTaxes = productService.create(organizationCode, product, request.getTaxes());
            return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ProductDto.from(productAndTaxes.getFirst(), productAndTaxes.getSecond()));
        } catch (InvalidDataException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @PutMapping("/{code}")
    public ResponseEntity<ProductDto> update(@PathVariable String organizationCode,
                                             @PathVariable String code,
                                             @Valid @RequestBody ProductDto request) {
        try {
            var product = productService.productOfOrganizationByCode(organizationCode, code);
            if (product == null) {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, "error.product_not_found");
            }

            product = product.toBuilder()
                .name(request.getName())
                .unitPrice(request.getUnitPrice())
                .build();
            var productAndTaxes = productService.save(product, request.getTaxes());

            return ResponseEntity
                .status(HttpStatus.OK)
                .body(ProductDto.from(productAndTaxes.getFirst(), productAndTaxes.getSecond()));
        } catch (InvalidDataException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }
}
