package org.bone.bridge.back.organizations.service;

import java.util.List;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.organizations.domain.Organization;
import org.bone.bridge.back.organizations.model.User;
import org.bone.bridge.back.organizations.repo.OrganizationRepo;
import org.bone.bridge.back.config.error.InvalidDataException;
import org.bone.bridge.back.config.service.UserConfigService;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrganizationService {
    private final OrganizationRepo organizationRepo;

    private final UserConfigService userConfigService;

    @NonNull
    public Organization create(@NonNull User user,
                               @NonNull Organization organization) throws InvalidDataException {
        var maxOrganizations = userConfigService.userMaxOrganizations(user.getUid());
        var organizationsCount = countOrganizationsOfUser(user);
        if (organizationsCount >= maxOrganizations) {
            throw new InvalidDataException("error.user_max_organizations_reached");
        }
        organization.setUserId(user.getUid());
        organization.setCode(availableCode(user, organization.getCode()));
        return organizationRepo.save(organization);
    }

    @NonNull
    public Organization save(@NonNull Organization organization) {
        return organizationRepo.save(organization);
    }

    public int countOrganizationsOfUser(@NonNull User user) {
        return organizationRepo.countByUserId(user.getUid());
    }

    @NonNull
    public List<Organization> organizationsOfUser(@NonNull User user) {
        return organizationRepo.findAllByUserId(user.getUid());
    }

    @Nullable
    public Organization organizationOfUserByCode(@NonNull User user, @NonNull String code) {
        return organizationRepo.findOneByUserIdAndCode(user.getUid(), code).orElse(null);
    }

    @Nullable
    public String availableCode(@NonNull User user, @Nullable String code) {
        if (code != null) {
            var codeExists = organizationRepo.existsByUserIdAndCode(user.getUid(), code);
            return codeExists ? null : code;
        }
        return null;
    }
}
