#!/bin/sh

jenv local

./gradlew app:bootJar

cd app
docker build -t sp1ke.dev/bone-bridge-app:latest .
