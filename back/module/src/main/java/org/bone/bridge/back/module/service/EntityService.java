package org.bone.bridge.back.module.service;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.module.domain.Entity;
import org.bone.bridge.back.module.repo.EntityRepo;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EntityService {
    private final EntityRepo entityRepo;
}
