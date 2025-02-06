package org.bone.bridge.back.config.repo;

import java.util.Optional;
import org.bone.bridge.back.config.domain.UserConfig;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface UserConfigRepo extends JpaRepository<UserConfig, Long>, JpaSpecificationExecutor<UserConfig> {
    Optional<UserConfig> findByUserId(String userId);
}
