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
        XCTAssertTrue(lasts.last??.askPrice.isNaN ?? false)
    }
}
