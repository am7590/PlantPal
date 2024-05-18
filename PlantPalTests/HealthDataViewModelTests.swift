//
//  HealthDataViewModelTests.swift
//  PlantPalTests
//
//  Created by Alek Michelson on 5/18/24.
//

//import XCTest
//@testable import PlantPal
//@testable import PlantPalCore
//@testable import PlantPalSharedUI

//class TestHelpers {
//    static let sharedGrpcViewModel = GRPCViewModel()
//    
//    static let healthPrediction = HealthPrediction(probability: 0.34, binary: false, threshold: 2.0)
//    static let healthResponse = HealthAssessmentResponse(result: HealthResult(isPlant: healthPrediction, isHealthy: healthPrediction, disease: DiseaseSuggestion(suggestions: [])))
//}

//class HealthDataViewModelTests: XCTestCase {
//    var viewModel: HealthDataViewModel!
//    var mockService: MockHealthDataService!
//    var sampleImage: UIImage!
//
//    override func setUp() {
//        super.setUp()
//        mockService = MockHealthDataService()
//        viewModel = HealthDataViewModel(service: mockService)
//        sampleImage = UIImage(systemName: "leaf")! // Make sure this image exists in your asset catalog or system images.
//    }
//
//    override func tearDown() {
//        viewModel = nil
//        mockService = nil
//        super.tearDown()
//    }
//
//    func testHealthDataViewModel_LoadingState() {
//        // Prepare
//        mockService.mockResponse = .success(TestHelpers.healthResponse)
//
//        // Execute
//        viewModel.fetchData(for: "Test Plant", id: "123", image: sampleImage)
//
//        // Assert
//        XCTAssertEqual(viewModel.loadState, .loading, "ViewModel should be in loading state immediately after fetching starts.")
//    }
//
//    func testHealthDataViewModel_SuccessfulFetch() {
//        // Prepare
//        let suggestion = IdentificationSuggestion(id: "1", name: "Test Disease", probability: 0.99, similarImages: [])
//        mockService.mockResponse = .success(TestHelpers.healthResponse)
//
//        let expectation = self.expectation(description: "Successful fetch of health data")
//        viewModel.fetchData(for: "Test Plant", id: "123", image: sampleImage)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if self.viewModel.healthData != nil && self.viewModel.loadState == .loaded {
//                expectation.fulfill()
//            }
//        }
//
//        waitForExpectations(timeout: 2, handler: nil)
//        XCTAssertEqual(viewModel.healthData?.result.isHealthy.probability, 0.99)
//    }
//
//    func testHealthDataViewModel_FailureFetch() {
//        // Prepare
//        mockService.mockResponse = .failure(NSError(domain: "TestError", code: 1, userInfo: nil))
//
//        let expectation = self.expectation(description: "Failed fetch of health data")
//        viewModel.fetchData(for: "Test Plant", id: "123", image: sampleImage)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if self.viewModel.loadState == .failed {
//                expectation.fulfill()
//            }
//        }
//
//        waitForExpectations(timeout: 2, handler: nil)
//    }
//}
