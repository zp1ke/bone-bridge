package org.bone.bridge.back.organizations;

import java.util.List;
import org.bone.bridge.back.organizations.domain.Organization;
import org.bone.bridge.back.organizations.model.User;
import org.bone.bridge.back.organizations.model.UserAuth;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class TestAuth {
    public static Authentication authOf(User user) {
        return authOf(user, null);
    }

    public static Authentication authOf(User user, Organization organization) {
        var token = "token";
        var userAuth = UserAuth.builder()
            .token(token)
            .user(user)
            .organization(organization)
            .build();
        return new UsernamePasswordAuthenticationToken(userAuth, token, List.of());
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable)
            .authorizeHttpRequests((authorize) ->
                authorize.anyRequest().authenticated()
            );
        return http.build();
    }
}
