package org.bone.bridge.back.countries.service;

import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Validator;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.countries.domain.OrganizationEcu;
import org.bone.bridge.back.countries.model.ecu.OrganizationEcuData;
import org.bone.bridge.back.countries.repo.OrganizationEcuRepo;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrganizationEcuService {
    private final OrganizationEcuRepo organizationEcuRepo;

    private final Validator validator;

    @NonNull
    public OrganizationEcuData save(@NonNull OrganizationEcuData data) throws ConstraintViolationException {
        var violations = validator.validate(data);
        if (!violations.isEmpty()) {
            throw new ConstraintViolationException("error.invalidData", violations);
        }
        var byOrganizationCode = organizationEcuRepo.findOneByOrganizationCode(data.getOrganizationCode());
        if (byOrganizationCode.isPresent()) {
            return update(byOrganizationCode.get(), data);
        }
        return create(data);
    }

    @NonNull
    private OrganizationEcuData create(@NonNull OrganizationEcuData data) {
        if (organizationEcuRepo.existsByLegalId(data.getLegalId())) {
            throw new ConstraintViolationException("error.legalIdAlreadyExists", Set.of());
        }
        return save(OrganizationEcu.builder(), data);
    }

    @NonNull
    private OrganizationEcuData update(@NonNull OrganizationEcu organizationEcu,
                                       @NonNull OrganizationEcuData data) throws ConstraintViolationException {
        if (!data.getLegalId().equals(organizationEcu.getLegalId()) &&
            organizationEcuRepo.existsByLegalIdAndOrganizationCodeIsNot(data.getLegalId(), organizationEcu.getOrganizationCode())) {
            throw new ConstraintViolationException("error.legalIdAlreadyExists", Set.of());
        }
        return save(organizationEcu.toBuilder(), data);
    }

    @NonNull
    private OrganizationEcuData save(@NonNull OrganizationEcu.OrganizationEcuBuilder<?, ?> builder,
                                     @NonNull OrganizationEcuData data) {
        var organization = builder
            .name(data.getName())
            .email(data.getEmail())
            .legalId(data.getLegalId())
            .legalIdType(data.getLegalIdType())
            .phone(data.getPhone())
            .address(data.getAddress())
            .build();
        organization = organizationEcuRepo.save(organization);
        return OrganizationEcuData.from(organization);
    }
}
