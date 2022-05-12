#!/usr/bin/env bash
# place this script in project/android/app/
cd ..
# fail if any command fails
set -e
# debug log
set -x

cd ..
# choose a different release channel if you want - https://github.com/flutter/flutter/wiki/Flutter-build-release-channels
# stable - recommended for production

git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable
flutter doctor

echo "Current branch: $APPCENTER_BRANCH"

if [ "$APPCENTER_BRANCH" == "staging" ]; then

  flutter build apk --release --flavor staging
  flutter build appbundle --release --flavor staging -t lib/main.dart
  mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/staging/release/app-staging-release.apk $_
  mkdir -p android/app/build/outputs/bundle/; mv build/app/outputs/bundle/stagingRelease/app-staging-release.aab $_

  fi

if [ "$APPCENTER_BRANCH" == "main" ]; then

  flutter build apk --release --flavor production
  flutter build appbundle --release --flavor production -t lib/main.dart
  mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/production/release/app-production-release.apk $_
  mkdir -p android/app/build/outputs/bundle/; mv build/app/outputs/bundle/productionRelease/app-production-release.aab $_

  fi

echo "Built branch: $APPCENTER_BRANCH"