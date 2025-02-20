package org.bone.bridge.back.sales.repo;

import org.bone.bridge.back.sales.domain.Estimate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface EstimateRepo extends JpaRepository<Estimate, Long>, JpaSpecificationExecutor<Estimate> {
}
