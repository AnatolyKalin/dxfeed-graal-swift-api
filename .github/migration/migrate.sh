#!/bin/bash
# The migration of DXFeedFramework to DxFeedGraalNativeSdk.xcframework: unpacks the zip into graal_builds (ditto keeps
# the links of the macOS framework), changes the project (migrate.rb) and points module.map (the Clang module
# graal_api that the Swift code imports) to a copy of the headers of the XCFramework.
set -euo pipefail
zip=$1
rm -rf graal_builds
mkdir graal_builds
ditto -x -k "${zip}" graal_builds
ruby -e "require 'xcodeproj'" 2>/dev/null || gem install --user-install --no-document xcodeproj
ruby .github/migration/migrate.rb
# The headers for module.map: a header in a framework belongs to the module of the framework (DxFeedGraalNativeSdk), so
# module.map cannot name it there; the headers of all the slices are the same.
mkdir graal_builds/include
cp graal_builds/DxFeedGraalNativeSdk.xcframework/ios-arm64/DxFeedGraalNativeSdk.framework/Headers/*.h graal_builds/include/
sed -i '' 's#header "graal_builds/ios/dxfg_api.h"#header "graal_builds/include/dxfg_api.h"#' module.map
cat module.map
git diff --stat
