package org.bone.bridge.back.app.service;

import java.util.List;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.app.domain.Organization;
import org.bone.bridge.back.app.model.User;
import org.bone.bridge.back.app.repo.OrganizationRepo;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrganizationService {
    private final OrganizationRepo organizationRepo;

    public short countOrganizationsOfUser(@NonNull User user) {
        return organizationRepo.countByUserId(user.getUid());
    }

    @NonNull
    public Organization save(@NonNull Organization organization) {
        return organizationRepo.save(organization);
    }

    @NonNull
    public List<Organization> organizationsOfUser(@NonNull User user) {
        return organizationRepo.findAllByUserId(user.getUid());
    }

    @Nullable
    public Organization organizationOfUserByCode(@NonNull User user, @NonNull String code) {
        return organizationRepo.findOneByUserIdAndCode(user.getUid(), code).orElse(null);
    }
}
