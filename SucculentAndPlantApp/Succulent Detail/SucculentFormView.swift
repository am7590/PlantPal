//
//  SucculentFormView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI
import PhotosUI
import ImageCaptureCore

struct SucculentFormView: View {
    @ObservedObject var viewModel: SuccuelentFormViewModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @StateObject var imageSelector = ImageSelector()
    @EnvironmentObject var imagePicker: ImageSelector
    
    @FetchRequest(sortDescriptors: [])
    var myImages: FetchedResults<Item>
    
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
                        Section("Name") {
                            TextField("", text: $viewModel.name)
                                .textFieldStyle(.plain)
                            
                            if viewModel.isItem {
                                NavigationLink(UserDefaults.standard.getIdentification(for: viewModel.name), destination: IdentificationView(images: viewModel.uiImage, plantName: viewModel.name))
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
            .onChange(of: imageSelector.uiImage) { newImage in
                if let newImage {
                    viewModel.uiImage.append(newImage)
                }
            }
            .navigationTitle(viewModel.updating ? "Edit Succulent" : "New Succulent")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if viewModel.updating {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button {
                                if let selectedImage = myImages.first(where: {$0.id == viewModel.id}) {
                                    moc.delete(selectedImage)
                                    try? moc.save()
                                }
                                dismiss()
                            } label: {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }
                    }
                }
                else {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Create") {
                            viewModel.snoozeAlertIsDispayed.toggle()
                            
                            // Create succulent
                            let newImage = Item(context: moc)
                            newImage.name = viewModel.name
                            newImage.id = UUID().uuidString
                            newImage.image = viewModel.uiImage
                            newImage.position = NSNumber(value: myImages.count)
                            try? moc.save()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.incomplete)
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
                    updateImage()  // After photo is appeneded in CameraHostingView
                }
            })
            .sheet(isPresented: $showHealthCheckSheet) {
                HealthReportView(image: viewModel.uiImage.first!, plantName: viewModel.name)
            }
            .alert("Add Plant Photo", isPresented: $viewModel.waterAlertIsDispayed) {
                Button("Take Photo") {
                    showCameraSheet = true
                }
                Button("Upload Photo") {
                    showPhotoSelectionSheet = true
                }
                Button("Cancel", role: .cancel) { }
            }
            .photosPicker(isPresented: $showPhotoSelectionSheet, selection: $newImageSelection)
            .onChange(of: newImageSelection) { newItem in
                Task {
                    do {
                        if let data = try await newItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                viewModel.uiImage.append(uiImage)
                                updateImage()
                            }
                        }
                    } catch {
                        print("womp womp: \(error.localizedDescription)")
                    }
                }
            }
            .onChange(of: imagePicker.imageSelection) { image in
                Task {
                    do {
                        if let data = try await image?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                viewModel.uiImage.append(uiImage)
                                updateImage()
                                print("Appending: \(uiImage)")
                            }
                        }
                    } catch {
                        print("womp womp: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func updateImage() {
        if let id = viewModel.id,
           let selectedImage = myImages.first(where: {$0.id == id}) {
            selectedImage.name = viewModel.name
            selectedImage.image = viewModel.uiImage
            if moc.hasChanges {
                try? moc.save()
            }
            withAnimation {
                viewModel.imagePageSliderIndex = viewModel.uiImage.count-1
            }
        }
    }
    
    @ViewBuilder func waterButton(width: CGFloat) -> some View {
        Button(action: { viewModel.waterAlertIsDispayed.toggle() }) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Image(systemName: "drop.fill")
                        .font(.title)
                    Text("Water")
                        .bold()
                        .font(.subheadline)
                }
                
                Spacer()
            }
            .padding(16)
            .frame(width: width/2 - 6)
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
        Section("Water Plant") {
            if !viewModel.isItem {
                Picker("Water", selection: $viewModel.amount) {
                    Text("As needed")
                        .tag(0)
                    ForEach(1..<11) { number in
                        Text("every " + number.description + " days")
                            .tag(number)
                    }
                }
            }
            
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
            
        }
        .listRowBackground(Color(uiColor: .secondarySystemBackground))
    }
}

struct NewSucculentFormView_Previews: PreviewProvider {
    static var previews: some View {
        SucculentFormView(viewModel: SuccuelentFormViewModel([UIImage(systemName: "photo")!]))
    }
}
