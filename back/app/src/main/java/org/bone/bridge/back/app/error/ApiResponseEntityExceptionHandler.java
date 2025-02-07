package org.bone.bridge.back.app.error;

import jakarta.validation.ConstraintViolationException;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@ControllerAdvice
public class ApiResponseEntityExceptionHandler extends ResponseEntityExceptionHandler {
    @ExceptionHandler(ConstraintViolationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ResponseBody
    Map<String, Object> onConstraintValidationException(ConstraintViolationException e) {
        var violations = e.getConstraintViolations().stream()
            .map(violation -> String.format("%s: %s", violation.getPropertyPath(), violation.getMessage()))
            .toList();
        return Map.of("message", e.getMessage(), "violations", violations);
    }
}
