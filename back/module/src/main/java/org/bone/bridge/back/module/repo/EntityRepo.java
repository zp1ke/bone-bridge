package org.bone.bridge.back.module.repo;

import java.util.Optional;
import org.bone.bridge.back.module.domain.Entity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface EntityRepo extends JpaRepository<Entity, Long>, JpaSpecificationExecutor<Entity> {
    Optional<Entity> findByUserId(String userId);
}
