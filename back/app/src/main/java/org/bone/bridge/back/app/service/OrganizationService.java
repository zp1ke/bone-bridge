package org.bone.bridge.back.app.service;

import java.time.OffsetDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.app.domain.Organization;
import org.bone.bridge.back.app.repo.OrganizationRepo;
import org.bone.bridge.back.app.repo.OrganizationSpec;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrganizationService {
    private final OrganizationRepo organizationRepo;

    @NonNull
    public Organization save(@NonNull Organization organization) {
        return organizationRepo.save(organization);
    }

    @NonNull
    public List<Organization> organizationsCreatedBetween(@NonNull OffsetDateTime from, @NonNull OffsetDateTime to) {
        var spec = OrganizationSpec.createdBetween(from, to);
        return organizationRepo.findAll(spec);
    }
}
