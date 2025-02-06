package org.bone.bridge.back.app.api;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.app.domain.Organization;
import org.bone.bridge.back.app.dto.OrganizationDto;
import org.bone.bridge.back.app.model.UserAuth;
import org.bone.bridge.back.app.service.OrganizationService;
import org.bone.bridge.back.app.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/organizations")
@RequiredArgsConstructor
public class OrganizationController {
    private final UserService userService;

    private final OrganizationService organizationService;

    @PostMapping
    public ResponseEntity<OrganizationDto> create(@AuthenticationPrincipal UserAuth userAuth,
                                                  @RequestBody OrganizationDto request) {
        var user = userAuth.getUser();
        var maxOrganizations = userService.userMaxOrganizations(user);
        var organizationsCount = organizationService.countOrganizationsOfUser(user);
        if (organizationsCount >= maxOrganizations) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
        var organization = organizationService
            .save(Organization.builder()
                .userId(user.getUid())
                .name(request.getName())
                .build());
        return ResponseEntity
            .status(HttpStatus.CREATED)
            .body(OrganizationDto.from(organization));
    }
}
