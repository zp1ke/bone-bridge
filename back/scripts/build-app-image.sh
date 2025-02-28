#!/bin/sh

jenv local

./gradlew app:bootJar

cd app
docker build -t zp1ke/bone-bridge-app:latest .
