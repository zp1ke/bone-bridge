package org.bone.bridge.back.config;

public interface Constants {
    String AUTH_HEADER = "Authorization";

    String HELLO_PATH = "/hello";
    String USERS_PATH = "/users";
    String ORGANIZATIONS_PATH = "/organizations";
    String PRODUCTS_PATH = "/products";

    short USER_DEFAULT_MAX_ORGANIZATIONS = 1;
    short ORGANIZATION_DEFAULT_MAX_PRODUCTS = 10;
}
