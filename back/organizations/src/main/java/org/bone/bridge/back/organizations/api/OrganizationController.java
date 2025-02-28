package org.bone.bridge.back.organizations.api;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.error.InvalidDataException;
import org.bone.bridge.back.countries.service.CountryService;
import org.bone.bridge.back.organizations.domain.Organization;
import org.bone.bridge.back.organizations.model.UserAuth;
import org.bone.bridge.back.organizations.model.dto.OrganizationDto;
import org.bone.bridge.back.organizations.service.OrganizationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping(Constants.ORGANIZATIONS_PATH)
@RequiredArgsConstructor
public class OrganizationController {
    private final OrganizationService organizationService;

    private final CountryService countryService;

    @PostMapping
    public ResponseEntity<OrganizationDto> create(@AuthenticationPrincipal UserAuth userAuth,
                                                  @Valid @RequestBody OrganizationDto request) {
        var user = userAuth.getUser();
        try {
            var organization = Organization.builder()
                .code(request.getCode())
                .name(request.getName())
                .email(request.getEmail())
                .phone(request.getPhone())
                .address(request.getAddress())
                .build();

            organization = organizationService.create(user, organization);
            return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(OrganizationDto.from(organization));
        } catch (InvalidDataException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @PutMapping("/{code}")
    public ResponseEntity<OrganizationDto> update(@AuthenticationPrincipal UserAuth userAuth,
                                                  @Valid @RequestBody OrganizationDto request) {
        var organization = userAuth.getOrganization();

        organization = organization.toBuilder()
            .name(request.getName())
            .email(request.getEmail())
            .phone(request.getPhone())
            .address(request.getAddress())
            .build();
        organization = organizationService.save(organization);

        var countryData = request.getCountryData();
        if (countryData != null) {
            countryData = countryService.saveOrganization(organization.getCode(), countryData);
        }

        return ResponseEntity
            .status(HttpStatus.OK)
            .body(OrganizationDto.from(organization, countryData));
    }
}
