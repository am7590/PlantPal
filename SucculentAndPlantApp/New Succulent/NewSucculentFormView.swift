//
//  NewSucculentFormView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI
import PhotosUI

struct NewSucculentFormView: View {
    @ObservedObject var viewModel: NewSucculentViewModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @StateObject var imagePicker = ImagePicker()
    
    @FetchRequest(sortDescriptors: [])
    private var myImages: FetchedResults<Item>
    
    @State private var name = ""
    
    var body: some View {
        NavigationStack {
            Image(uiImage: viewModel.uiImage)
                .resizable()
                .scaledToFit()
            
            TextField("Name", text: $viewModel.name)
            
            HStack {
                Text("Date Taken")
                Spacer()
                if viewModel.dateHidden {
                    Text("No Date")
                    Button("Set Date") {
                        viewModel.date = Date()
                    }
                } else {
                    HStack {
                        DatePicker("", selection: $viewModel.date, in: ...Date(), displayedComponents: .date)
                        Button("Clear date") {
                            viewModel.date = Date.distantPast
                        }
                    }
                }
            }
            .padding()
            .buttonStyle(.bordered)
            
            HStack {
                if viewModel.updating {
                    PhotosPicker("Change Image",
                                 selection: $imagePicker.imageSelection,
                                 matching: .images,
                                 photoLibrary: .shared())
                    .buttonStyle(.bordered)
                }
                Button {
                    if viewModel.updating {
                        updateImage()
                        dismiss()
                    } else {
                        let newImage = Item(context: moc)
                        newImage.name = viewModel.name
                        newImage.id = UUID().uuidString
                        newImage.image = viewModel.uiImage
                        try? moc.save()
                        dismiss()
                    }
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(viewModel.incomplete)
            }
            
            Spacer()
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(viewModel.updating ? "Update Image" : "New Image")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            if viewModel.updating {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            if let selectedImage = myImages.first(where: {$0.id == viewModel.id}) {
//                                    FileManager().deleteImage(with: selectedImage.imageID)
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
        }
        .onChange(of: imagePicker.uiImage) { newImage in
            if let newImage {
                viewModel.uiImage = newImage
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
}

struct NewSucculentFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewSucculentFormView(viewModel: NewSucculentViewModel(UIImage(systemName: "photo")!))
    }
}
