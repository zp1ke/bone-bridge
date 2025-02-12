package org.bone.bridge.back.config.service;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.domain.OrganizationConfig;
import org.bone.bridge.back.config.repo.OrganizationConfigRepo;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrganizationConfigService {
    private final OrganizationConfigRepo organizationConfigRepo;

    public short organizationMaxProducts(@NonNull String organizationCode) {
        var userConfig = organizationConfig(organizationCode);
        return userConfig.getMaxProducts();
    }

    @NonNull
    private OrganizationConfig organizationConfig(@NonNull String organizationCode) {
        return organizationConfigRepo
            .findByOrganizationCode(organizationCode)
            .orElseGet(() -> organizationConfigRepo.save(
                OrganizationConfig.builder()
                    .organizationCode(organizationCode)
                    .maxProducts(Constants.ORGANIZATION_DEFAULT_MAX_PRODUCTS)
                    .build()));
    }
}
