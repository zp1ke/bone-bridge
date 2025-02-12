package org.bone.bridge.back.products.repo;

import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.products.domain.Product;
import org.bone.bridge.back.products.domain.ProductTax;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ProductTaxRepo extends JpaRepository<ProductTax, Long>, JpaSpecificationExecutor<ProductTax> {
    void deleteAllByProductAndCountry(Product product, Country country);
}
