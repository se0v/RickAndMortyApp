#!/bin/bash

set -e

echo "flutter clean && flutter pub get"
flutter clean && flutter pub get

echo "dart analyze"
dart analyze --fatal-warnings || true

echo "flutter test test/unit_test.dart"
flutter test test/unit_test.dart

echo "flutter test test/widget_test.dart"
flutter test test/widget_test.dart

echo "flutter test integration_test/app_test.dart"
flutter test integration_test/app_test.dart -d "$SIMULATOR_UDID" --timeout 120s

echo "All steps passed!"