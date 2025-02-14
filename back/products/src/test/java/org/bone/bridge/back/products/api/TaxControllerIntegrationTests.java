package org.bone.bridge.back.products.api;

import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.countries.repo.TaxEcuRepo;
import org.bone.bridge.back.products.TestcontainersConfig;
import org.bone.bridge.back.products.model.dto.TaxDto;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.context.annotation.Import;
import org.springframework.http.HttpStatus;
import static org.junit.jupiter.api.Assertions.*;

@Import(TestcontainersConfig.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class TaxControllerIntegrationTests {
    @Autowired
    TaxEcuRepo taxEcuRepo;

    @Autowired
    TestRestTemplate testRestTemplate;

    @Test
    void taxesECU_ShouldReturnTaxesEnabled() {
        var url = String.format("%s/%s/%s", Constants.TAXES_PATH, Country.ECU.name(), TaxType.VAT.name());
        var response = testRestTemplate.getForEntity(url, TaxDto[].class);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());

        var taxes = taxEcuRepo.findAllByTaxTypeAndEnabled(TaxType.VAT, true);
        assertEquals(taxes.size(), response.getBody().length);

        for (var taxDto : response.getBody()) {
            var tax = taxes.stream().filter(t -> t.getPercentage()
                .equals(taxDto.getPercentage())).findFirst();
            assertTrue(tax.isPresent());
            assertEquals(tax.get().getCountryCode(), taxDto.getCode());
        }
    }
}
