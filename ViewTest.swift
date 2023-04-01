import XCTest
@testable import PathFinder

class ViewControllerTests: XCTestCase {

    var viewController: SearchViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        viewController.loadViewIfNeeded()
    }

    func testViewController_tableViewIsNotNil() {
        XCTAssertNotNil(viewController.tableView)
    }

    func testViewController_searchBarIsNotNil() {
        XCTAssertNotNil(viewController.navigationItem)
    }

}
