package org.bone.bridge.back.app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;
import static org.springframework.security.web.util.matcher.AntPathRequestMatcher.antMatcher;

@Configuration
public class Security {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable)
            .authorizeHttpRequests((authorize) ->
                authorize
                    .requestMatchers(HttpMethod.GET, "/actuator/**").permitAll()
                    .requestMatchers(antMatcher(HttpMethod.GET, "/api/**/hello")).permitAll()
                    .anyRequest().authenticated()
            );
        return http.build();
    }
}
