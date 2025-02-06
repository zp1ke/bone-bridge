package org.bone.bridge.back.app.api;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.regex.Pattern;
import javax.security.auth.login.AccountException;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.app.domain.Organization;
import org.bone.bridge.back.app.model.User;
import org.bone.bridge.back.app.model.UserAuth;
import org.bone.bridge.back.app.service.OrganizationService;
import org.bone.bridge.back.app.service.UserService;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

@RequiredArgsConstructor
public class AuthFilter extends OncePerRequestFilter {
    private static final Pattern ORGANIZATION_PATTERN = Pattern.compile("/organizations/(\\w+)(/.*)?");

    final UserService userService;

    final OrganizationService organizationService;

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request,
                                    @NonNull HttpServletResponse response,
                                    @NonNull FilterChain filterChain) throws ServletException, IOException {
        var token = authToken(request);
        if (token != null) {
            var user = userService.userFromAuthToken(token);
            if (user != null) {
                createUserAuth(user, token, request);
            }
        }
        filterChain.doFilter(request, response);
    }

    private void createUserAuth(@NonNull User user, @NonNull String token, @NonNull HttpServletRequest request) {
        try {
            var organization = organizationOfRequest(user, request);
            var userAuth = UserAuth.builder()
                .token(token)
                .user(user)
                .organization(organization)
                .build();
            var authentication = new UsernamePasswordAuthenticationToken(userAuth, token, List.of());
            authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(authentication);
        } catch (AccountException ignored) {
            SecurityContextHolder.clearContext();
        }
    }

    @Nullable
    private Organization organizationOfRequest(@NonNull User user, @NonNull HttpServletRequest request) throws AccountException {
        var organizationCode = organizationCodeFromPath(request.getRequestURI());
        if (organizationCode != null) {
            var organization = organizationService.organizationOfUserByCode(user, organizationCode);
            if (organization != null) {
                return organization;
            }
            throw new AccountException();
        }
        return null;
    }

    @Nullable
    public static String organizationCodeFromPath(@NonNull String path) {
        var matcher = ORGANIZATION_PATTERN.matcher(path);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    @Nullable
    private String authToken(@NonNull HttpServletRequest request) {
        var authorization = request.getHeader("Authorization");
        if (authorization != null) {
            var parts = authorization.trim().split(" ");
            return parts[parts.length - 1];
        }
        return null;
    }
}
