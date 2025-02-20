package org.bone.bridge.back.sales.service;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.sales.repo.EstimateRepo;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EstimateService {
    private final EstimateRepo entityRepo;
}
