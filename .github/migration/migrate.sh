#!/bin/bash
# The migration of DXFeedFramework to DxFeedGraalNativeSdk.xcframework: unpacks the zip into graal_builds (ditto keeps
# the links of the macOS framework), changes the project (migrate.rb) and points module.map (the Clang module
# graal_api that the Swift code imports) to the headers of the XCFramework.
set -euo pipefail
zip=$1
rm -rf graal_builds
mkdir graal_builds
ditto -x -k "${zip}" graal_builds
ruby -e "require 'xcodeproj'" 2>/dev/null || gem install --user-install --no-document xcodeproj
ruby .github/migration/migrate.rb
sed -i '' 's#header "graal_builds/ios/dxfg_api.h"#header "graal_builds/DxFeedGraalNativeSdk.xcframework/ios-arm64/DxFeedGraalNativeSdk.framework/Headers/dxfg_api.h"#' module.map
cat module.map
git diff --stat
