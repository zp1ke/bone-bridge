package org.bone.bridge.back.app.api;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.app.service.UserService;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

@RequiredArgsConstructor
public class AuthFilter extends OncePerRequestFilter {
    final UserService userService;

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request,
                                    @NonNull HttpServletResponse response,
                                    @NonNull FilterChain filterChain) throws ServletException, IOException {
        var token = authToken(request);
        if (token != null) {
            var user = userService.userFromAuthToken(token);
            if (user != null) {
                var authentication = new UsernamePasswordAuthenticationToken(user, token, List.of());
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        }
        filterChain.doFilter(request, response);
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
