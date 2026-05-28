#!/bin/bash

set -e

echo "🔐 Setting up secrets..."

if [ -z "$GOOGLE_PLAY_JSON_KEY" ]; then
    echo "FATAL: GOOGLE_PLAY_JSON_KEY is empty in GitHub Secrets!"
    exit 1
fi

if [ -z "$KEYSTORE_BASE64" ]; then
    echo "FATAL: KEYSTORE_BASE64 is empty in GitHub Secrets!"
    exit 1
fi

echo "Secrets found."

mkdir -p android/fastlane
mkdir -p android/app

echo "Writing Play Store Key..."
printf '%s\n' "$GOOGLE_PLAY_JSON_KEY" > android/fastlane/play-store-key.json

echo "Writing Keystore..."
echo "$KEYSTORE_BASE64" | base64 --decode > android/app/key.jks

echo "--- DEBUG: First 5 lines of play-store-key.json ---"
head -n 5 android/fastlane/play-store-key.json
echo "--- END DEBUG ---"

FILE_SIZE=$(stat -f%z "android/fastlane/play-store-key.json" 2>/dev/null || stat -c%s "android/fastlane/play-store-key.json")
echo "File size: $FILE_SIZE bytes"

if [ "$FILE_SIZE" -lt 100 ]; then
    echo "ERROR: File is too small! Check your secret."
    exit 1
fi

echo "Files created successfully."

echo "flutter clean && flutter pub get"
flutter clean && flutter pub get

echo "flutter build apk --release"
flutter build apk --release

echo "fastlane deploy"
cd android
fastlane deploy

echo "CD completed!"