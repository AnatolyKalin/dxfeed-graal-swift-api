import SdkSmoke
import XCTest

final class SdkSmokeTests: XCTestCase {
    func testIsolateArgument() {
        XCTAssertEqual(SdkSmoke.property("smoke.property", arguments: ["-Dsmoke.property=xcframework"]), "xcframework")
    }

    func testJavaVm() {
        XCTAssertEqual(SdkSmoke.property("java.vm.name", arguments: []), "Substrate VM")
    }
}
