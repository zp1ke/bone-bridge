package org.bone.bridge.back.app.api;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.app.dto.OrganizationDto;
import org.bone.bridge.back.app.dto.UserProfile;
import org.bone.bridge.back.app.model.UserAuth;
import org.bone.bridge.back.app.service.OrganizationService;
import org.bone.bridge.back.config.service.UserConfigService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {
    private final UserConfigService userConfigService;

    private final OrganizationService organizationService;

    @GetMapping("/profile")
    public ResponseEntity<UserProfile> profile(@AuthenticationPrincipal UserAuth userAuth) {
        var user = userAuth.getUser();
        var organizations = organizationService
            .organizationsOfUser(user).stream()
            .map(OrganizationDto::from)
            .toList();
        var userProfile = UserProfile.builder()
            .name(user.getName())
            .email(user.getEmail())
            .maxOrganizations(userConfigService.userMaxOrganizations(user.getUid()))
            .organizations(organizations)
            .build();
        return ResponseEntity.ok(userProfile);
    }
}
