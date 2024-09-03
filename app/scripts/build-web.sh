#!/bin/sh

flutter build web --base-href "/bone-bridge/" --wasm --dart-define-from-file "config.json"
