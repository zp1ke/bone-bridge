package org.bone.bridge.back.app.api;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.app.domain.Organization;
import org.bone.bridge.back.app.model.UserAuth;
import org.bone.bridge.back.app.model.dto.OrganizationDto;
import org.bone.bridge.back.app.service.OrganizationService;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.error.InvalidDataException;
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
