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
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @StateObject var imageSelector = ImageSelector()
    @EnvironmentObject var imagePicker: ImageSelector
    
    @State var navLinkValue = ""
    
    @FetchRequest(sortDescriptors: [])
    public var myImages: FetchedResults<Item>
    
    @State private var showCameraSheet = false
    @State private var showPhotoSelectionSheet = false
    @State private var showHealthCheckSheet = false
    
    @State var newImageSelection: PhotosPickerItem?
    
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
//                        Section(viewModel.isItem ? "Species ID" : "Name") {
//                            if !viewModel.isItem {
//                                TextField("", text: $viewModel.name)
//                                    .textFieldStyle(.plain)
//                            }
//
//                            if viewModel.isItem {
//                                //                                NavigationLink(navLinkValue, destination: IdentificationView(viewModel: viewModel, grpcViewModel: grpcViewModel))
//                                                         
//                                
//                                NavigationLink(navLinkValue, destination:
//                                    EmptyView()
////                                    IdentificationView(dismiss: dismiss, viewModel: IdentificationViewModel(grpcViewModel: grpcViewModel, plantFormViewModel: viewModel, identificationService: <#T##PlantIdentificationServiceProtocol#>))
//                                    .onDisappear {
//                                        refreshUserDefaults()
//                                    }
//                                )
//                            }
//                        }
//                        .listRowBackground(Color(uiColor: .secondarySystemBackground))
//
//                        waterPlantView()
//
//                        if !viewModel.isItem {
//                            selectImageView(width: width)
//                                .listRowBackground(Color(uiColor: .secondarySystemBackground))
//                        }
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
                if !viewModel.updating {
                    UpdatingToolbar(viewModel: viewModel) {
                        let newItem = viewModel.updateItem(myImages: myImages)
                        grpcViewModel.createNewPlant(identifier: newItem.id ?? "0", name: viewModel.name)
                        dismiss()
                    }
                } else {
                    CreateToolbar() {
                        viewModel.createItem(myImages: myImages)
                        grpcViewModel.removePlantEntry(with: viewModel.id ?? "0")
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(uiColor: .systemOrange))
                }
            }
            .sheet(isPresented: $showCameraSheet, onDismiss: {
                
            }, content: {
                CameraHostingView(viewModel: viewModel) {
                    viewModel.updateImage(item: myImages.first(where: {$0.id == viewModel.id}))  // After photo is appeneded in CameraHostingView
                    // If gRPC call is successful, change "last watered"
                }
            })
            .sheet(isPresented: $showHealthCheckSheet) {
//                HealthReportView(viewModel: viewModel, grpcViewModel: grpcViewModel)
            }
            .onAppear {
                refreshUserDefaultsIfNeccesary()
            }
            .onChange(of: imageSelector.uiImage) { newImage in
               appendNewImageIfNeccesary(image: newImage)
            }
            .alert("Add Plant Photo", isPresented: $viewModel.waterAlertIsDispayed) {
                Button("Take Photo") {
                    showCameraSheet = true
                    grpcViewModel.updateExistingPlant(with: viewModel.id!, name: viewModel.name, lastWatered: Int64(Date().timeIntervalSince1970), lastHealthCheck: nil, lastIdentification: nil, identifiedSpeciesName: nil, newHealthProbability: nil)
                }
                Button("Upload Photo") {
                    showPhotoSelectionSheet = true
                    grpcViewModel.updateExistingPlant(with: viewModel.id!, name: viewModel.name, lastWatered: Int64(Date().timeIntervalSince1970), lastHealthCheck: nil, lastIdentification: nil, identifiedSpeciesName: nil, newHealthProbability: nil)
                }
                Button("Cancel", role: .cancel) { }
            }
            .photosPicker(isPresented: $showPhotoSelectionSheet, selection: $newImageSelection)
//            .onChange(of: newImageSelection) { newItem in
//                viewModel.handleNewImageSelection(newItem: newItem)
//            }
//            .onChange(of: imagePicker.imageSelection) { image in
//                viewModel.handleNewImageSelection(newItem: image)
//            }
            .onChange(of: viewModel.date) { newDate in
                if let id = UserDefaults.standard.getUUID(for: viewModel.name), !viewModel.name.isEmpty, viewModel.date != Date.now.stripTime() {
                    // TODO: Move this to viewModel
                    
                    let interval = viewModel.date.timeIntervalSince1970 * 86400
                    grpcViewModel.updateExistingPlant(with: id, name: viewModel.name, lastWatered: Int64(interval), lastHealthCheck: nil, lastIdentification: nil, identifiedSpeciesName: nil, newHealthProbability: nil)
    
                    item?.timestamp = viewModel.date
                    try? moc.save()
                }
            }
            .onChange(of: viewModel.amount) { newAmount in
                if let id = UserDefaults.standard.getUUID(for: viewModel.name), newAmount != 0 {
                    // TODO: Move this to viewModel
                    
                    let interval = viewModel.date.timeIntervalSince1970 * 86400
                    grpcViewModel.updateExistingPlant(with: id, name: viewModel.name, lastWatered: Int64(interval), lastHealthCheck: nil, lastIdentification: nil, identifiedSpeciesName: nil, newHealthProbability: nil)
                    item?.interval = ((viewModel.amount) as NSNumber)
                    try? moc.save()
                }
            }


        }
    }
    
    
    func refreshUserDefaults() {
        self.navLinkValue = UserDefaults.standard.getIdentification(for: viewModel.name)
        
        // TODO: Move this to viewModel
        viewModel.date = item?.timestamp ?? Date.now
        viewModel.amount = Int(item?.interval ?? 0)
    }
    
    func createItem(myImages: FetchedResults<Item>) {
        viewModel.snoozeAlertIsDispayed.toggle()
        
        // Create plant
        let newItem = Item(context: moc)
        newItem.name = viewModel.name
        newItem.id = UUID().uuidString
        newItem.image = viewModel.uiImage
        newItem.position = NSNumber(value: myImages.count)
        newItem.timestamp = viewModel.date
        newItem.interval = (viewModel.amount) as NSNumber
        try? moc.save()
        
        grpcViewModel.createNewPlant(identifier: newItem.id ?? "69420", name: viewModel.name)
        
        UserDefaults.standard.hasGeneratedUUID(for: viewModel.name, with: newItem.id!)
    }
    
    

    
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
    
    @ViewBuilder func healthCheckButton(width: CGFloat) -> some View {
        Button(action: { showHealthCheckSheet.toggle() }) {
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
                showCameraSheet = true
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
//        .tint(Color(uiColor: .systemOrange))

    }
}

//struct NewSucculentFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        SucculentFormView(item: ,viewModel: SuccuelentFormViewModel([UIImage(systemName: "photo")!]), grpcViewModel: GRPCViewModel())
//    }
//}
