package org.bone.bridge.back.countries.service.ecu;

import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Validator;
import java.util.Set;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.countries.domain.OrganizationEcu;
import org.bone.bridge.back.countries.model.OrganizationData;
import org.bone.bridge.back.countries.model.ecu.OrganizationEcuData;
import org.bone.bridge.back.countries.repo.OrganizationEcuRepo;
import org.bone.bridge.back.countries.service.OrganizationService;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrganizationEcuService implements OrganizationService<OrganizationEcuData> {
    private final OrganizationEcuRepo organizationEcuRepo;

    private final Validator validator;

    @NonNull
    @Override
    public OrganizationEcuData save(@NonNull String organizationCode,
                                    @NonNull OrganizationData organizationData) throws ConstraintViolationException {
        var data = (OrganizationEcuData) organizationData;
        var violations = validator.validate(data);
        if (!violations.isEmpty()) {
            throw new ConstraintViolationException("error.invalidData", violations);
        }
        var byOrganizationCode = organizationEcuRepo.findOneByOrganizationCode(organizationCode);
        return byOrganizationCode
            .map(organizationEcu -> update(organizationEcu, data))
            .orElseGet(() -> create(organizationCode, data));
    }

    @Override
    public Class<OrganizationEcuData> getDataClass() {
        return OrganizationEcuData.class;
    }

    @NonNull
    private OrganizationEcuData create(@NonNull String organizationCode,
                                       @NonNull OrganizationEcuData data) {
        if (organizationEcuRepo.existsByLegalId(data.getLegalId())) {
            throw new ConstraintViolationException("error.legalIdAlreadyExists", Set.of());
        }
        var builder = OrganizationEcu.builder().organizationCode(organizationCode);
        return save(builder, data);
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
