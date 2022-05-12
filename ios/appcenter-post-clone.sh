#!/usr/bin/env bash
#Place this script in project/ios/

# fail if any command fails
set -e
# debug log
set -x

cd ..
#git clone -b stable https://github.com/flutter/flutter.git
# test clone flutter version 2.5.2 hash 3595343e20a61ff16d14e8ecc25f364276bb1b8b
git clone https://github.com/flutter/flutter.git
#git checkout 3595343e20a61ff16d14e8ecc25f364276bb1b8b

export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable
flutter doctor

echo "Installed flutter to `pwd`/flutter"

echo "Current branch is $APPCENTER_BRANCH"

if [ "$APPCENTER_BRANCH" == "staging" ]; then

  flutter build ios --release --flavor staging -t lib/main.dart --no-codesign

  fi
if [ "$APPCENTER_BRANCH" == "main" ]; then

  flutter build ios --release --flavor production -t lib/main.dart --no-codesign

  fi

echo "Built branch $APPCENTER_BRANCH"