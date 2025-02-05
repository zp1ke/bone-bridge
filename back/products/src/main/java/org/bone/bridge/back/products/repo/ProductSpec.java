package org.bone.bridge.back.products.repo;

import java.time.OffsetDateTime;
import org.bone.bridge.back.data.repo.BaseSpec;
import org.bone.bridge.back.products.domain.Product;
import org.springframework.data.jpa.domain.Specification;

public class ProductSpec {
    public static Specification<Product> createdBetween(OffsetDateTime from, OffsetDateTime to) {
        return BaseSpec.createdBetween(from, to);
    }
}
