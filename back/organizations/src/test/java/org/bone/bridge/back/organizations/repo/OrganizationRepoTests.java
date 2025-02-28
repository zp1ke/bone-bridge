package org.bone.bridge.back.organizations.repo;

import java.time.OffsetDateTime;
import org.bone.bridge.back.organizations.TestcontainersConfig;
import org.bone.bridge.back.organizations.domain.Organization;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.context.annotation.Import;
import org.testcontainers.junit.jupiter.Testcontainers;
import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@Testcontainers
@Import(TestcontainersConfig.class)
public class OrganizationRepoTests {
    @Autowired
    OrganizationRepo organizationRepo;

    @Test
    void testSaveOrganization() {
        var data = Organization.builder()
            .code("Test")
            .userId("Test")
            .name("Test Organization")
            .email("test@mail.com")
            .build();
        var organization = organizationRepo.save(data);
        assertNotNull(organization.getId());
        assertEquals(data.getCode(), organization.getCode());
        assertEquals(data.getName(), organization.getName());
    }

    @Test
    void testFindOrganizationsCreatedBetween() {
        var organization = organizationRepo.save(Organization.builder()
            .code("Test")
            .userId("Test")
            .name("Test Organization")
            .email("test@mail.com")
            .build());

        var now = OffsetDateTime.now();
        var spec = OrganizationSpec.createdBetween(now.minusMinutes(1L), now);
        var organizations = organizationRepo.findAll(spec);
        assertNotNull(organizations);
        assertFalse(organizations.isEmpty());
        assertEquals(1, organizations.size());
        assertEquals(organization.getCode(), organizations.getFirst().getCode());
        assertEquals(organization.getName(), organizations.getFirst().getName());

        spec = OrganizationSpec.createdBetween(now, now.plusMinutes(1L));
        organizations = organizationRepo.findAll(spec);
        assertNotNull(organizations);
        assertTrue(organizations.isEmpty());

        spec = OrganizationSpec.createdBetween(now.minusMinutes(2L), now.minusMinutes(1L));
        organizations = organizationRepo.findAll(spec);
        assertNotNull(organizations);
        assertTrue(organizations.isEmpty());
    }
}
