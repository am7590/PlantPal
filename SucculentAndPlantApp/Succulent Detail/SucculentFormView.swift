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
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                VStack {
                    let width = proxy.size.width - 28
                    
                    if let image = viewModel.uiImage, viewModel.isItem {
                    
                        ImageSliderContainerView(imgArr: [image, image, image])
                            .cornerRadius(24)
                        HStack {
                            Button(action: { viewModel.waterAlertIsDispayed.toggle() }) {
                                VStack {
                                    Image(systemName: "drop.fill")
                                    Text("Water")
                                }
                                .padding(16)
                                .frame(width: width/2 - 6)
                                .background(Color.blue.opacity(0.25))
                                .cornerRadius(24)
                            }
                            
                            Button(action: { viewModel.snoozeAlertIsDispayed.toggle() }) {
                                VStack {
                                    Image(systemName: "moon.zzz.fill")
                                    Text("Snooze")
                                }
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(width: width/2 - 6)
                                .background(Color.secondary.opacity(0.25))
                                .cornerRadius(24)
                            }
                        }
                        .frame(width: width + 8)
                        .padding(.top)
                    }
                    
                    List {
                        // TODO: Open keypad and select this TextField upon opening .new view type
                        Section("Name") {
                            TextField("", text: $viewModel.name)
                                .textFieldStyle(.plain)
                        }
                        .listRowBackground(Color(uiColor: .secondarySystemBackground))
                        
                        waterPlantView()
                        
                        
                        if !viewModel.isItem {
                            selectImageView(width: width)
                        }
                    }
                    .cornerRadius(24)
                    .scrollContentBackground(.hidden)
                
                    Spacer()
                }
                
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .onChange(of: imageSelector.uiImage) { newImage in
                if let newImage {
                    viewModel.uiImage = newImage
                }
            }
            .navigationTitle(viewModel.updating ? "Update Succulent" : "New Succulent")
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
                } else {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // TODO: Make this tinted if the user has not filled out all fields
                        Button("Create") {
                            viewModel.snoozeAlertIsDispayed.toggle()
                            
                            // Create succulent
                            let newImage = Item(context: moc)
                            newImage.name = viewModel.name
                            newImage.id = UUID().uuidString
                            newImage.image = viewModel.uiImage
                            try? moc.save()
                            dismiss()
                        }
//                        .buttonStyle(.bordered)
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
            .sheet(isPresented: $showCameraSheet) {
                CameraHostingView()
            }
        }
        
    }
    
    func updateImage() {
        if let id = viewModel.id,
           let selectedImage = myImages.first(where: {$0.id == id}) {
            selectedImage.name = viewModel.name
            selectedImage.image = viewModel.uiImage
            //            FileManager().saveImage(with: id, image: viewModel.uiImage)
            if moc.hasChanges {
                try? moc.save()
            }
        }
    }
    
    @ViewBuilder func selectImageView(width imageWidth: CGFloat) -> some View {
        Section("Image") {
                VStack(alignment: .leading) {
                    Button("Take Photo...") {
                        showCameraSheet = true
                        
                    }
                    .foregroundColor(Color(uiColor: .systemOrange))
                    //
                    Divider()
                    
                    HStack {
                        PhotosPicker("Choose Image", selection: $imagePicker.imageSelection,
                                     matching: .images,
                                     photoLibrary: .shared())
                        .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    
                    if let image = viewModel.uiImage, let _ = imagePicker.imageSelection {
                        Divider()
                        
                        HStack {
//                            Spacer()
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
//                                .frame(width: imageWidth, height: imageWidth)
                                //.aspectRatio(contentMode: .fit)
                                .cornerRadius(24)
//                            Spacer()
                        }
                    }
                }
            }
            .listRowBackground(Color(uiColor: .secondarySystemBackground))
        
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
                        //                                Button("Clear") {
                        //                                    viewModel.date = Date.distantPast
                        //                                }
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
        SucculentFormView(viewModel: SuccuelentFormViewModel(UIImage(systemName: "photo")!))
    }
}
