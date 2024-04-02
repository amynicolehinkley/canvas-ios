//
// This file is part of Canvas.
// Copyright (C) 2024-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import Core
import XCTest

class LTIDomainsTests: XCTestCase {

    func testIcons() {
        XCTAssertEqual(LTIDomains.studio.icon, .studioLine)
        XCTAssertEqual(LTIDomains.gauge.icon, .ltiLine)
        XCTAssertEqual(LTIDomains.gauge.icon, LTIDomains.defaultIcon)
        XCTAssertEqual(LTIDomains.masteryConnect.icon, .masteryLTI)
    }

    func testRawValues() {
        XCTAssertEqual(LTIDomains.studio.rawValue, "arc.instructure.com")
        XCTAssertEqual(LTIDomains.gauge.rawValue, "gauge.instructure.com")
        XCTAssertEqual(LTIDomains.masteryConnect.rawValue, "app.masteryconnect.com")
    }
}
