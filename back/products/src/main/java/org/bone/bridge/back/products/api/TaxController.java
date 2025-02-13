package org.bone.bridge.back.products.api;

import java.util.List;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.model.TaxType;
import org.bone.bridge.back.countries.model.Country;
import org.bone.bridge.back.countries.service.CountryService;
import org.bone.bridge.back.products.model.dto.TaxDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(Constants.TAXES_PATH)
@RequiredArgsConstructor
public class TaxController {
    private final CountryService countryService;

    @GetMapping("/{country}/{taxType}")
    public ResponseEntity<List<TaxDto>> taxes(@PathVariable Country country,
                                              @PathVariable TaxType taxType) {
        var taxes = countryService.taxes(country, taxType).stream()
            .map(tax -> TaxDto.from(tax))
            .toList();
        return ResponseEntity.ok(taxes);
    }
}
