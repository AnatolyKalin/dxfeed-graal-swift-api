import DxFeedGraalNativeSdk
import Foundation

public enum SdkSmoke {
    /// Creates an isolate with the isolate arguments, reads a system property and tears the isolate down.
    public static func property(_ name: String, arguments: [String]) -> String? {
        var cArguments: [UnsafeMutablePointer<CChar>?] = (["smoke"] + arguments).map { strdup($0) }
        defer { cArguments.forEach { free($0) } }
        var params = graal_create_isolate_params_t()
        params.version = Int32(__graal_create_isolate_params_version)
        params.argc = Int32(cArguments.count)
        var isolate: OpaquePointer?
        var thread: OpaquePointer?
        let result: Int32 = cArguments.withUnsafeMutableBufferPointer { buffer in
            params.argv = buffer.baseAddress
            return graal_create_isolate(&params, &isolate, &thread)
        }
        guard result == 0, let thread else {
            return nil
        }
        defer { _ = graal_tear_down_isolate(thread) }
        guard let value = dxfg_system_get_property(thread, name) else {
            return nil
        }
        defer { _ = dxfg_system_release_property(thread, value) }
        return String(cString: value)
    }
}
