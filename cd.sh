#!/bin/bash

set -e

echo "flutter clean && flutter pub get"
flutter clean && flutter pub get

echo "flutter build apk --release"
flutter build apk --release

echo "fastlane deploy"
cd android && fastlane deploy

echo "CD completed!"
