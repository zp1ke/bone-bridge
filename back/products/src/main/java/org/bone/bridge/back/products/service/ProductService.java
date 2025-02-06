package org.bone.bridge.back.products.service;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.products.domain.Product;
import org.bone.bridge.back.products.repo.ProductRepo;
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
}
