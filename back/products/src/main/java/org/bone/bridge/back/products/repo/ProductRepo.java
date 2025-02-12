package org.bone.bridge.back.products.repo;

import java.util.Optional;
import org.bone.bridge.back.products.domain.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ProductRepo extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {
    int countByOrganizationCode(String organizationCode);

    boolean existsByOrganizationCodeAndCode(String organizationCode, String code);

    Optional<Product> findOneByOrganizationCodeAndCode(String organizationCode, String code);
}
