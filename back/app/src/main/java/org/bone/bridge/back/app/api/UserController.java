package org.bone.bridge.back.app.api;

import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.app.dto.OrganizationDto;
import org.bone.bridge.back.app.dto.UserProfile;
import org.bone.bridge.back.app.model.UserAuth;
import org.bone.bridge.back.app.service.OrganizationService;
import org.bone.bridge.back.app.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

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
            .maxOrganizations(userService.userMaxOrganizations(user))
            .organizations(organizations)
            .build();
        return ResponseEntity.ok(userProfile);
    }
}
