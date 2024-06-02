//
//  SucculentFormView+Helpers.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/18/24.
//

import SwiftUI
import CoreData
import _PhotosUI_SwiftUI

// MARK: Helpers
// Cannot be moved to viewModel
extension SucculentFormView {
    func refreshUserDefaultsIfNeccesary() {
        if !viewModel.name.isEmpty {
            refreshUserDefaults()
        }
    }
    
    func appendNewImageIfNeccesary(image newImage: UIImage?) {
        if let newImage {
            viewModel.uiImage.append(newImage)
        }
    }
    
    func refreshUserDefaults() {
        viewModel.navLinkValue = UserDefaults.standard.getIdentification(for: viewModel.name)
        
        // TODO: Move this to viewModel
        viewModel.date = item?.timestamp ?? Date.now
        viewModel.amount = Int(item?.interval ?? 0)
    }
}


// MARK: Updating toolbar
extension SucculentFormView {
    struct UpdatingToolbar: ToolbarContent {
        @ObservedObject var viewModel: SuccuelentFormViewModel
        var updateItemCallback: () -> Void
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    updateItemCallback()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(uiColor: .systemGreen))
                .disabled(viewModel.incomplete)
            }
        }
    }
}

// MARK: Create plant toolbar
extension SucculentFormView {
    struct CreateToolbar: ToolbarContent {
        var createItemCallback: () -> Void
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        createItemCallback()
                        
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .tint(.primary)
                }
            }
        }
    }
}

// MARK: Views
extension SucculentFormView {
    @ViewBuilder func waterButton(width: CGFloat) -> some View {
        Button(action: {
            viewModel.waterAlertIsDispayed.toggle()
            
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Image(systemName: "drop.fill")
                        .font(.title)
                        .tint(.blue)

                    Text("Water")
                        .bold()
                        .font(.subheadline)
                        .tint(.blue)

                }
                
                Spacer()
            }
            .padding(16)
            .frame(width: width/2 - 6)
            .frame(height: 85)
            .background(Color.blue.opacity(0.25))
            .cornerRadius(12)
        }
    }
    
    @ViewBuilder func addPlantPhotoButtons() -> some View {
        Button("Take Photo") {
            viewModel.showCameraSheet = true
            grpcViewModel.updateExistingPlant(with: viewModel.id!, name: viewModel.name, lastWatered: Int64(Date().timeIntervalSince1970), lastHealthCheck: nil, lastIdentification: nil, identifiedSpeciesName: nil, newHealthProbability: nil)
        }
        
        Button("Upload Photo") {
            viewModel.showPhotoSelectionSheet = true
            grpcViewModel.updateExistingPlant(with: viewModel.id!, name: viewModel.name, lastWatered: Int64(Date().timeIntervalSince1970), lastHealthCheck: nil, lastIdentification: nil, identifiedSpeciesName: nil, newHealthProbability: nil)
        }
        
        Button("Cancel", role: .cancel) { }
    }
    
    @ViewBuilder func healthCheckButton(width: CGFloat) -> some View {
        Button(action: { viewModel.showHealthCheckSheet.toggle() }) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Image(systemName: "heart.text.square")
                        .font(.title)
                    
                    Text("Health Check")
                        .bold()
                        .font(.subheadline)
                    
                    //                                        Text("Water another time")
                    //                                            .foregroundColor(.clear)
                    //                                            .font(.caption)
                }
                
                Spacer()
            }
            .foregroundColor(.secondary)
            .padding()
            .frame(width: width/2 - 6)
            .frame(height: 85)
            .background(Color.secondary.opacity(0.25))
            .cornerRadius(12)
        }
    }
    
    @ViewBuilder func selectImageView(width imageWidth: CGFloat) -> some View {
        
        // Take photo
        VStack(alignment: .leading) {
            Button("Take Photo...") {
                viewModel.showCameraSheet = true
            }
            .foregroundColor(Color(uiColor: .systemOrange))
        }
        
        // Choose image
        HStack {
            PhotosPicker("Choose Image", selection: $imagePicker.imageSelection,
                         matching: .images,
                         photoLibrary: .shared())
            .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        
        // Display image
        if let image = viewModel.uiImage.first {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(16)
        }
    }
    
    
    
    @ViewBuilder func waterPlantView() -> some View {
        Section("Watering") {
            HStack {
                Text("Last Watered")
                Spacer()
                if viewModel.dateHidden {
                    Text("No Date")
                    Button("Set Date") {
                        viewModel.date = Date()

                    }
                } else {
                    HStack {
                        DatePicker("", selection: $viewModel.date, in: ...Date(), displayedComponents: .date)
                    }
                }
            }
            .buttonStyle(.bordered)
            
            Picker(viewModel.isItem ? "Watering" : "Water", selection: $viewModel.amount) {
                Text("As needed")
                    .tag(0)
                ForEach(1..<11) { number in
                    Text("every " + number.description + " days")
                        .tag(number)
                }
            }
        }
        .listRowBackground(Color(uiColor: .secondarySystemBackground))
    }
}
