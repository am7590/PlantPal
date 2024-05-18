//
//  SucculentListView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/7/23.
//

import SwiftUI
import CoreData
import BRYXBanner
import _PhotosUI_SwiftUI
import PlantPalSharedUI
import PlantPalCore

struct SucculentListView: View {    
    @EnvironmentObject var router: Router
    @EnvironmentObject var imagePicker: ImageSelector
    @EnvironmentObject var viewModel: SucculentListViewModel
    @EnvironmentObject var shareService: PersistImageService
    @EnvironmentObject var grpcViewModel: GRPCViewModel
    
    // Plants fetched from CoreData
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    var fetchedItems: FetchedResults<Item>
    
    // Triggers deep link detail view
    // I know this isn't best practice :( I would only do this in a personal project
    let pub = NotificationCenter.default.publisher(for: NSNotification.deepLink)

    @State var items: [Item] = []
    @State var draggedItem: Item?
        
    var body: some View {
        NavigationStack(path: $router.path) {
            GeometryReader { proxy in
                let cellWidth = proxy.size.width/2 - 24
                
                Group {
                    if items.isEmpty {
                        // User has no plants; tell them to create one
                        ErrorHandlingView(listType: .noData)
                    } else {
                        // List user's plants in list or grid form
                        ScrollView {
                            if viewModel.isList {
                                listView(width: cellWidth)
                            } else {
                                LazyVGrid(columns: viewModel.gridItemLayout, spacing: 16) {
                                    listView(width: cellWidth)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("All Plants")
                .searchable(text: $viewModel.searchText, prompt: "Search")
                .toolbar {
                    CustomToolbar()
                }
                .sheet(item: $viewModel.formState, onDismiss: {
                    refreshFetchedItems()
                }) { $0 }
                .alert("Image Updated", isPresented: $viewModel.imageExists) {
                    Button("OK") {}
                }
                .onChange(of: shareService.codeableImage) { codableImage in
                    updateOrRestoreImage(codableImage, fetchedItems)
                }
                .onChange(of: viewModel.searchText) { value in
                    updateItemsFromSearchQuery(value)
                }
                .onAppear {
                    refreshFetchedItems()
                }
                .onReceive(pub) { obj in
                    if let userInfo = obj.object as? [String:String], let url = userInfo["url"] {
                        handleDeepLinkingToItem(url: url, grpcViewModel: grpcViewModel)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.foundCloudkitUUID)) { notification in
                    saveiCloudUUID(notification: notification)
                }
            }
        }
    }
}

// MARK: List/Grid View
extension SucculentListView {
    func listView(width cellWidth: CGFloat) -> some View {
        ForEach(items, id: \.self) { item in
            // Items can be dragged and dropped to reorder
            // TODO: Send list index to gRPC server to save reordering
            let dropDelegate = MyDropDelegate(item: item, items: $items, draggedItem: draggedItem)
            
            Button {
                viewModel.formState = .edit(item, grpcViewModel)
            } label: {
                ZStack(alignment: .topLeading) {
                    Image(uiImage: item.uiImage.last ?? UIImage(systemName: "trash")!)
                        .resizable()
                        .scaledToFill()
                        .modifier(CustomFrameModifier(active: !viewModel.isList, width: cellWidth))
                        .clipped()
                        .cornerRadius(16)
                        .shadow(radius: 8.0)
                }
                .onDrag {
                    viewModel.wiggle = false
                    draggedItem = item
                    return NSItemProvider(object: NSString())
                }
                .rotationEffect(.degrees(viewModel.wiggle ? 2.5 : 0))
                .animation(.easeInOut(duration: 0.14).repeat(while: viewModel.wiggle), value: viewModel.wiggle)
                .onTapGesture {
                    viewModel.formState = .edit(item, grpcViewModel)
                }
                .onLongPressGesture(minimumDuration: 1) {
                    viewModel.wiggle.toggle()
                }
            }
            .onDrop(of: [UTType.text], delegate: dropDelegate)
        }
    }
}
