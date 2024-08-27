#!/bin/sh

dart pub global activate arb_utils
arb_utils sort lib/l10n/app_en.arb;
flutter gen-l10n
