package org.bone.bridge.back.sales.service;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.sales.domain.Entity;
import org.bone.bridge.back.sales.repo.EntityRepo;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EntityService {
    private final EntityRepo entityRepo;
}
