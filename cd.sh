#!/bin/bash

set -e

mkdir -p android/fastlane
echo "$GOOGLE_PLAY_JSON_KEY" > android/fastlane/play-store-key.json

mkdir -p android/app
echo "$KEYSTORE_BASE64" | base64 --decode > android/app/key.jks

echo "flutter clean && flutter pub get"
flutter clean && flutter pub get

echo "flutter build apk --release"
flutter build apk --release

echo "fastlane deploy"
cd android && fastlane deploy

echo "CD completed!"
