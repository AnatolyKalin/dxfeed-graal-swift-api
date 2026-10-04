import DXFeedFramework
import SpmSmoke
import XCTest

final class SpmSmokeTests: XCTestCase {
    func testLastQuotes() throws {
        let (last, lasts) = try SpmSmoke.lastQuotes(symbol: "SPM", askPrice: 101.5)
        XCTAssertEqual(last?.eventSymbol, "SPM")
        XCTAssertEqual(last?.askPrice, 101.5)
        XCTAssertEqual(lasts.count, 2)
        XCTAssertEqual(lasts.first??.askPrice, 101.5)
        XCTAssertEqual(lasts.last??.eventSymbol, "SPM_NONE")
        // Not available: a copy of the requested event, which dxfg_EventType_new makes with zeros (as before).
        XCTAssertEqual(lasts.last??.askPrice, 0)
    }
}
