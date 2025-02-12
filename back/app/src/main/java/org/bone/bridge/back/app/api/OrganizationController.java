package org.bone.bridge.back.app.api;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.app.domain.Organization;
import org.bone.bridge.back.app.dto.OrganizationDto;
import org.bone.bridge.back.app.model.UserAuth;
import org.bone.bridge.back.app.service.OrganizationService;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.service.UserConfigService;
import org.bone.bridge.back.countries.service.CountryService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping(Constants.ORGANIZATIONS_PATH)
@RequiredArgsConstructor
public class OrganizationController {
    private final UserConfigService userConfigService;

    private final OrganizationService organizationService;

    private final CountryService countryService;

    @PostMapping
    public ResponseEntity<OrganizationDto> create(@AuthenticationPrincipal UserAuth userAuth,
                                                  @Valid @RequestBody OrganizationDto request) {
        var user = userAuth.getUser();
        var maxOrganizations = userConfigService.userMaxOrganizations(user.getUid());
        var organizationsCount = organizationService.countOrganizationsOfUser(user);
        if (organizationsCount >= maxOrganizations) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "error.user_max_organizations_reached");
        }
        var code = organizationService.availableCode(user, request.getCode());
        var organization = organizationService
            .save(Organization.builder()
                .userId(user.getUid())
                .code(code)
                .name(request.getName())
                .email(request.getEmail())
                .phone(request.getPhone())
                .address(request.getAddress())
                .build());
        return ResponseEntity
            .status(HttpStatus.CREATED)
            .body(OrganizationDto.from(organization));
    }

    @PostMapping("/{code}")
    public ResponseEntity<OrganizationDto> update(@AuthenticationPrincipal UserAuth userAuth,
                                                  @Valid @RequestBody OrganizationDto request) {
        var organization = userAuth.getOrganization();

        organization = organizationService
            .save(organization.toBuilder()
                .name(request.getName())
                .email(request.getEmail())
                .phone(request.getPhone())
                .address(request.getAddress())
                .build());

        var countryData = request.getCountryData();
        if (countryData != null) {
            countryData = countryService.saveOrganization(organization.getCode(), countryData);
        }

        return ResponseEntity
            .status(HttpStatus.OK)
            .body(OrganizationDto.from(organization, countryData));
    }
}
