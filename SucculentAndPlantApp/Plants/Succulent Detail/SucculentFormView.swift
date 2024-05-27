//
//  SucculentFormView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI
import PhotosUI
import ImageCaptureCore
import os

struct SucculentFormView: View {
    let item: Item?

    @ObservedObject var viewModel: SuccuelentFormViewModel
    @ObservedObject var grpcViewModel: GRPCViewModel

    @Environment(\.dismiss) var dismiss
    
    @StateObject var imageSelector = ImageSelector()
    @EnvironmentObject var imagePicker: ImageSelector

    @FetchRequest(sortDescriptors: [])
    public var myImages: FetchedResults<Item>
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack {
                    let width = proxy.size.width - 28
                    
                    if viewModel.isItem {

                        ImagePageSliderView(images: viewModel.uiImage, currentIndex: $viewModel.imagePageSliderIndex)
                            .padding([.horizontal, .top])
                            .padding(.vertical, 16)
                            .padding(.top, 16)

                        HStack {
                            waterButton(width: width)
                            healthCheckButton(width: width)
                        }
                        .padding(.top, 54)
                        .background(.clear)
                    }
                    
                    List {
                        // TODO: Open keypad and select this TextField upon opening .new view type
                        Section(viewModel.isItem ? "Species ID" : "Name") {
                            if !viewModel.isItem {
                                TextField("", text: $viewModel.name)
                                    .textFieldStyle(.plain)
                            }

                            if viewModel.isItem {
                                //                                NavigationLink(navLinkValue, destination: IdentificationView(viewModel: viewModel, grpcViewModel: grpcViewModel))
                                                         
                                
                                NavigationLink(viewModel.navLinkValue, destination:
                                    EmptyView()
//                                    IdentificationView(dismiss: dismiss, viewModel: IdentificationViewModel(grpcViewModel: grpcViewModel, plantFormViewModel: viewModel, identificationService: <#T##PlantIdentificationServiceProtocol#>))
                                    .onDisappear {
                                        refreshUserDefaults()
                                    }
                                )
                            }
                        }
                        .listRowBackground(Color(uiColor: .secondarySystemBackground))

                        waterPlantView()

                        if !viewModel.isItem {
                            selectImageView(width: width)
                                .listRowBackground(Color(uiColor: .secondarySystemBackground))
                        }
                    }
                    .cornerRadius(16)
                    .scrollContentBackground(.hidden)

                    Spacer()
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .navigationTitle(viewModel.updating ? "\(viewModel.name)" : "New Plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                SucculentFormViewToolbar(viewModel: viewModel, grpcViewModel: grpcViewModel, myImages: myImages)
            }
            .sheet(isPresented: $viewModel.showCameraSheet, onDismiss: {
            }, content: {
                CameraHostingView(viewModel: viewModel) {
                    // After photo is appeneded in CameraHostingView
                    // TODO: If gRPC call is successful, change "last watered" value in the db
                    viewModel.updateImage(item: myImages.first(where: {$0.id == viewModel.id}))
                }
            })
            .sheet(isPresented: $viewModel.showHealthCheckSheet) {
                HealthReportView(viewModel: viewModel, grpcViewModel: grpcViewModel, healthDataViewModel: HealthDataViewModel())
            }
            .alert("Add Plant Photo", isPresented: $viewModel.waterAlertIsDispayed) {
                addPlantPhotoButtons()
            }
            .photosPicker(isPresented: $viewModel.showPhotoSelectionSheet, selection: $viewModel.newImageSelection)
            .onAppear {
                refreshUserDefaultsIfNeccesary()
            }
            .onChange(of: viewModel.newImageSelection) { newItem in
                viewModel.handleNewImageSelection(newItem: newItem)
            }
            .onChange(of: imagePicker.imageSelection) { image in
                viewModel.handleNewImageSelection(newItem: image)
            }
            .onChange(of: viewModel.date) { _ in
                item?.timestamp = viewModel.updateExistingPlant()
            }
            .onChange(of: viewModel.amount) { _ in
                viewModel.updateExistingPlant()
            }
            .onChange(of: imageSelector.uiImage) { newImage in
               appendNewImageIfNeccesary(image: newImage)
            }
        }
    }
}
