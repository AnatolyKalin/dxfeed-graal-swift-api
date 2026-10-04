# Moves DXFeedFramework from the files of the graal-native-sdk archives (graal_builds/ios, ios_simulator, osx_*) to
# graal_builds/DxFeedGraalNativeSdk.xcframework: the steps of the migration guide, made with the xcodeproj gem.
require 'xcodeproj'

project = Xcodeproj::Project.open('DXFeedFramework.xcodeproj')
target = project.targets.find { |t| t.name == 'DXFeedFramework' } or abort 'no DXFeedFramework target'
dylib = project.files.find { |f| f.path.to_s.end_with?('libDxFeedGraalNativeSdk.dylib') } or abort 'no dylib'
embed = target.copy_files_build_phases.find { |p| p.name == 'Embed Libraries' } or abort 'no Embed Libraries'

# 1. The universal dylib: linked and embedded on macOS.
project.objects.select { |o| o.isa == 'PBXBuildFile' && o.file_ref == dylib }.each(&:remove_from_project)
dylib.remove_from_project

# 2. The run script phase that made graal_builds/osx_universal with lipo.
target.shell_script_build_phases.select { |p| p.shell_script.include?('osx_universal') }.each(&:remove_from_project)

# 3. The XCFramework: linked on every platform (Xcode takes the slice of the platform), embedded on macOS only (the
#    frameworks for iOS and the simulator are static).
framework = project.main_group.new_reference('graal_builds/DxFeedGraalNativeSdk.xcframework')
framework.source_tree = 'SOURCE_ROOT'
framework.last_known_file_type = 'wrapper.xcframework'
target.frameworks_build_phase.add_file_reference(framework)
embedded = embed.add_file_reference(framework)
embedded.settings = { 'ATTRIBUTES' => %w[CodeSignOnCopy RemoveHeadersOnCopy] }
embedded.platform_filters = ['macos']

# 4. The linker flags of the files and their search paths are not needed any more.
target.build_configurations.each do |config|
  settings = config.build_settings
  settings.delete('OTHER_LDFLAGS[sdk=iphoneos*]')
  settings.delete('OTHER_LDFLAGS[sdk=iphonesimulator*]')
  settings['LIBRARY_SEARCH_PATHS'] = ['$(inherited)']
end

project.save
puts 'DXFeedFramework links graal_builds/DxFeedGraalNativeSdk.xcframework'
