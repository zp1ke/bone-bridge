package org.bone.bridge.back.products.service;

import java.time.OffsetDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.products.domain.Product;
import org.bone.bridge.back.products.repo.ProductRepo;
import org.bone.bridge.back.products.repo.ProductSpec;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepo productRepo;

    @NonNull
    public Product save(@NonNull Product product) {
        return productRepo.save(product);
    }

    @NonNull
    public List<Product> productsCreatedBetween(@NonNull OffsetDateTime from, @NonNull OffsetDateTime to) {
        var spec = ProductSpec.createdBetween(from, to);
        return productRepo.findAll(spec);
    }
}
