//
//  SucculentFormView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI
import PhotosUI

struct SucculentFormView: View {
    @ObservedObject var viewModel: SuccuelentFormViewModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @StateObject var imagePicker = ImagePicker()
    
    @FetchRequest(sortDescriptors: [])
    private var myImages: FetchedResults<Item>
    
    @State private var name = ""
    @State var amount = 0
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                let width = proxy.size.width - 28
                
                Image(uiImage: viewModel.uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width)
                    .cornerRadius(24)

                HStack {
                    Button(action: {}) {
                        VStack {
                            Image(systemName: "drop.fill")
                            Text("Water")
                        }
                        .padding(16)
                        .frame(width: width/2 - 6)
                        .background(Color.blue.opacity(0.25))
                        .cornerRadius(24)
                    }
                    
                    
                    Button(action: {}) {
                        VStack {
                            Image(systemName: "fanblades.fill")
                            Text("Fertilize")
                        }
                        .foregroundColor(.red)
                        .padding()
                        .frame(width: width/2 - 6)
                        .background(Color.red.opacity(0.25))
                        .cornerRadius(24)
                    }
                }
                .frame(width: width + 8)
                .padding(.top)
                
                List {
                    Section("General Info") {
                        TextField("Name", text: $viewModel.name)
                            .textFieldStyle(.plain)
                    }
                    .listRowBackground(Color(uiColor: .secondarySystemBackground))
                    
                    Section("Water Plant") {
                        if !viewModel.isItem {
                            Picker("Water", selection: $amount) {
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
                .cornerRadius(24)
                .scrollContentBackground(.hidden)
                
                if !viewModel.isItem {
                    HStack {
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
                        .tint(.blue)
                        .disabled(viewModel.incomplete)
                    }
                }
                                
                Spacer()
            }
            
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(viewModel.updating ? "Update Succulent" : "New Succulent")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    let newImage = Item(context: moc)
                    newImage.name = viewModel.name
                    newImage.id = UUID().uuidString
                    newImage.image = viewModel.uiImage
                    try? moc.save()
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
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
        SucculentFormView(viewModel: SuccuelentFormViewModel(UIImage(systemName: "photo")!))
    }
}
