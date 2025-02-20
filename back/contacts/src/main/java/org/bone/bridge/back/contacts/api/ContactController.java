package org.bone.bridge.back.contacts.api;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.bone.bridge.back.config.Constants;
import org.bone.bridge.back.config.error.InvalidDataException;
import org.bone.bridge.back.contacts.domain.Contact;
import org.bone.bridge.back.contacts.model.dto.ContactDto;
import org.bone.bridge.back.contacts.service.ContactService;
import org.bone.bridge.back.countries.service.CountryService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping(Constants.ORGANIZATIONS_PATH + "/{organizationCode}" + Constants.CONTACTS_PATH)
@RequiredArgsConstructor
public class ContactController {
    private final ContactService contactService;

    private final CountryService countryService;

    @PostMapping
    public ResponseEntity<ContactDto> create(@PathVariable String organizationCode,
                                             @Valid @RequestBody ContactDto request) {
        try {
            var contact = Contact.builder()
                .code(request.getCode())
                .name(request.getName())
                .email(request.getEmail())
                .build();

            contact = contactService.create(organizationCode, contact);
            return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ContactDto.from(contact));
        } catch (InvalidDataException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }

    @PutMapping("/{code}")
    public ResponseEntity<ContactDto> update(@PathVariable String organizationCode,
                                             @PathVariable String code,
                                             @Valid @RequestBody ContactDto request) {
        try {
            var contact = contactService.contactOfOrganizationByCode(organizationCode, code);
            if (contact == null) {
                throw new ResponseStatusException(HttpStatus.NOT_FOUND, "error.contact_not_found");
            }

            contact = contact.toBuilder()
                .name(request.getName())
                .email(request.getEmail())
                .build();
            contact = contactService.save(contact);

            var countryData = request.getCountryData();
            if (countryData != null) {
                countryData = countryService.saveContact(contact.getCode(), countryData);
            }

            return ResponseEntity
                .status(HttpStatus.OK)
                .body(ContactDto.from(contact, countryData));
        } catch (InvalidDataException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getMessage());
        }
    }
}
