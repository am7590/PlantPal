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

struct SucculentListView: View {    
    @EnvironmentObject var router: Router
    @EnvironmentObject var imagePicker: ImageSelector
    @EnvironmentObject var viewModel: SucculentListViewModel
    @EnvironmentObject var shareService: PersistImageService
    @EnvironmentObject var grpcViewModel: GRPCViewModel
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    var fetchedItems: FetchedResults<Item>
    
    let pub = NotificationCenter.default.publisher(for: NSNotification.deepLink)

    @State var items: [Item] = []
    @State var draggedItem: Item?
        
    var body: some View {
        NavigationStack(path: $router.path) {
            GeometryReader { proxy in
                let cellWidth = proxy.size.width/2 - 24
                
                Group {
                    if items.isEmpty {
                        ErrorHandlingView(listType: .noData)
                    } else {
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
//                .onChange(of: imagePicker.uiImage) { newImage in
//                    if let newImage {
//                        viewModel.handleImageChange([newImage])
//                    }
//                }
                .onChange(of: shareService.codeableImage) { codableImage in
                    updateOrRestoreImage(codableImage, fetchedItems)
                }
                .onChange(of: viewModel.searchText) { value in
                    updateItemsFromSearchQuery(value)
                }
                .onAppear {
                    refreshFetchedItems()
                }
//                .onOpenURL { url in
//                    handleDeepLinkingToItem(url: url)
//                }
                .onReceive(pub) { obj in
                    if let userInfo = obj.object as? [String:String], let url = userInfo["url"] {
                        handleDeepLinkingToItem(url: url, grpcViewModel: grpcViewModel)
                    }
                }
            }
        }
    }
    
    func refreshFetchedItems() {
        items = Array(fetchedItems)
    }
    
    func listView(width cellWidth: CGFloat) -> some View {
        ForEach(items, id: \.self) { item in
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
                       
                    
                    
//                    if UserDefaults.standard.getHealthScore(for: item.nameText) != 0 {
//                        CircularProgressView(progress: UserDefaults.standard.getHealthScore(for: item.nameText), color: UserDefaults.standard.getHealthScore(for: item.nameText) < 50 ? .red : .green, size: CircularProgressViewSize.small, showProgress: true)
//                    }
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