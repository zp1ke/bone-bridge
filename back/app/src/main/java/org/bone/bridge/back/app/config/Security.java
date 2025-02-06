package org.bone.bridge.back.app.config;

import org.bone.bridge.back.app.api.AuthFilter;
import org.bone.bridge.back.app.service.OrganizationService;
import org.bone.bridge.back.app.service.UserService;
import org.bone.bridge.back.config.Constants;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
public class Security {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   UserService userService,
                                                   OrganizationService organizationService) throws Exception {
        var authFilter = new AuthFilter(userService, organizationService);
        http
            .csrf(AbstractHttpConfigurer::disable)
            .authorizeHttpRequests((authorize) ->
                authorize
                    .requestMatchers(HttpMethod.GET, "/actuator/**").permitAll()
                    .requestMatchers(HttpMethod.GET, Constants.HELLO_PATH).permitAll()
                    .anyRequest().authenticated()
            ).addFilterBefore(authFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }
}
