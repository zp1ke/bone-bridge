#!/bin/sh

echo ""
flutter --version

git config --global --add safe.directory /workspaces/*

echo ""
if [ $(dpkg-query -W -f='${Status}' appwrite 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo "Appwrite CLI not found. Installing...";
  curl -sL https://appwrite.io/cli/install.sh | bash;
  appwrite client --endpoint https://cloud.appwrite.io/v1;
fi
appwrite -v
