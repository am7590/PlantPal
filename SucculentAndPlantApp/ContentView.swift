//
//  ContentView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI
import CoreData
import _PhotosUI_SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: Router
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var shareService: PersistImageService
    @StateObject private var imagePicker = ImagePicker()
    @State private var formState: NewSucculentFormState?
    @State private var imageExists = false
    @State private var searchText = ""
    @State private var isList = false
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    private var items: FetchedResults<Item>
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationStack(path: $router.path) {
            GeometryReader { proxy in
                let cellWidth = proxy.size.width/2 - 24
                
                Group {
                    if items.isEmpty {
                        EmptyGridView(listType: .allSucculents)
                            .padding(.leading, 24)
                    } else {
                        ScrollView {
                            if isList {
                                listView(width: cellWidth)
                            } else {
                                LazyVGrid(columns: gridItemLayout, spacing: 16) {
                                    listView(width: cellWidth)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .onOpenURL { url in
                    guard let scheme = url.scheme, scheme == "navStack" else { return }
                    guard let item = url.host else { return }
                    if let foundItem = items.first(where: { $0.nameText.lowercased() == item }) {
                        router.reset()
                        formState = .edit(foundItem)
                    }
                }
                .navigationTitle("All Succulents")
                .searchable(text: $searchText, prompt: "Search")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                isList = false
                            } label: {
                                Label("Grid", systemImage: "rectangle.grid.2x2")
                            }
                            
                            Button {
                                isList = true
                            } label: {
                                Label("List", systemImage: "list.bullet")
                            }
                            
                        } label: {
                            Image(systemName: isList ? "list.bullet" : "rectangle.grid.2x2")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        PhotosPicker(selection: $imagePicker.imageSelection,
                                     matching: .images,
                                     photoLibrary: .shared()) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .onChange(of: imagePicker.uiImage) { newImage in
                    if let newImage {
                        formState = .new(newImage)
                    }
                }
                .onChange(of: shareService.codeableImage) { codableImage in
                    if let codableImage {
                        if let item = items.first(where: {$0.id == codableImage.id}) {
                            // Update
                            updateInfo(myItem: item)
                            imageExists.toggle()
                        } else {
                            // New
                            restoreMyImage()
                        }
                    }
                }
                .onChange(of: searchText) { value in
                    if searchText != "" {
                        items.nsPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
                    } else {
                        items.nsPredicate = nil
                    }
                }
                .sheet(item: $formState) { $0 }
                .alert("Image Updated", isPresented: $imageExists) {
                    Button("OK") {}
                }
            }
        }
    }
    
    func listView(width cellWidth: CGFloat) -> some View {
        ForEach(items) { item in
            Button {
                print("poo hoo")
                formState = .edit(item)
            } label: {
                Image(uiImage: item.uiImage)
                    .resizable()
                    .scaledToFill()
                    .modifier(CustomFrameModifier(active: !isList, width: cellWidth))
                    .clipped()
                    .cornerRadius(24)
                    .shadow(radius: 8.0)
            }
        }
    }
    
    func restoreMyImage() {
        if let codableImage = shareService.codeableImage {
            let imgURL = URL.documentsDirectory.appending(path: "\(codableImage.id).jpg")
            let newImage = Item(context: viewContext)
            if let data = try? Data(contentsOf: imgURL), let uiImage = UIImage(data: data) {
                newImage.image = uiImage
            }
            newImage.name = codableImage.name
            newImage.id = codableImage.id
            try? viewContext.save()
            try? FileManager().removeItem(at: imgURL)
        }
        shareService.codeableImage = nil
    }
    
    func updateInfo(myItem: Item) {
        if let codableImage = shareService.codeableImage {
            let imgURL = URL.documentsDirectory.appending(path: "\(codableImage.id).jpg")
            if let data = try? Data(contentsOf: imgURL), let uiImage = UIImage(data: data) {
                myItem.image = uiImage
            }
            myItem.name = codableImage.name
            myItem.id = codableImage.id
            try? viewContext.save()
            try? FileManager().removeItem(at: imgURL)
        }
        shareService.codeableImage = nil
    }
    
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//
//    }
    
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct LazyVGridModifier: ViewModifier {
    var active : Bool
    var gridItemLayout = [GridItem(.adaptive(minimum: 150))]
    
    @ViewBuilder func body(content: Content) -> some View {
        if active {
            LazyVGrid(columns: gridItemLayout, spacing: 16) {
                content
            }
        } else {
            content
        }
    }
}

struct CustomFrameModifier: ViewModifier {
    var active: Bool
    var width: CGFloat
    
    @ViewBuilder func body(content: Content) -> some View {
        if active {
            content.frame(width: width, height: width, alignment: .center)
        } else {
            content
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
