//
//  IdentificationViewModelTests.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/18/24.
//

import XCTest
@testable import PlantPalCore
@testable import PlantPalSharedUI
@testable import PlantPal

class IdentificationViewModelTests: XCTestCase {
    var viewModel: IdentificationViewModel!
    var mockService: MockPlantIdentificationService!
    var grpcViewModel: GRPCViewModel!
    var plantFormViewModel: SuccuelentFormViewModel!
    
    override func setUp() {
        super.setUp()
        grpcViewModel = GRPCViewModel()
        plantFormViewModel = SuccuelentFormViewModel([])
        mockService = MockPlantIdentificationService()
        viewModel = IdentificationViewModel(grpcViewModel: grpcViewModel,
                                            plantFormViewModel: plantFormViewModel,
                                            identificationService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        grpcViewModel = nil
        plantFormViewModel = nil
        super.tearDown()
    }

    func testIdentificationViewModel_SuccessfulDataLoad() {
        let expectation = self.expectation(description: "Successful data fetch")
        
        viewModel.fetchData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if case .loaded = self.viewModel.loadState, self.viewModel.identificationData != nil {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5.0) { error in
            if let error  {
                XCTFail("\(#function) Failed with error: \(error)")
            }
        }
    }

    func testIdentificationViewModel_HandlesEmptySuggestions() {
        mockService.identifyPlantHandler = { _, _, completion in
            let response = IdentificationResponse(result: IdentificationResult(classification: IdentificationClassification(suggestions: [])))
            completion(.success(response))
        }
        
        let expectation = self.expectation(description: "Empty suggestions gandled")
        
        viewModel.fetchData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if case .loaded = self.viewModel.loadState, self.viewModel.identificationData?.result?.classification?.suggestions?.isEmpty == true {
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5.0) { error in
            if let error {
                XCTFail("\(#function) Failed with error: \(error)")
            }
        }
    }
}
