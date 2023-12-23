//
//  TrendsView.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 11/19/23.
//

import SwiftUI

class TrendsViewModel: ObservableObject {
    @Published var data: [[Item]]
    @Published var isLoading: Bool = true
    
    init(data: [[Item]]) {
        self.data = data
        
        // Temporary
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoading = false
        }
    }
    
    public func addData(data: [Item]) {
        self.data.append(data)
    }
}

struct TrendsView: View {
    // Plants fetched from CoreData
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    var fetchedItems: FetchedResults<Item> 
    
    @ObservedObject var viewModel = TrendsViewModel(data: [])

    var body: some View {
        NavigationStack {
            Group {
                if fetchedItems.isEmpty {
                    ErrorHandlingView(listType: .noDataTrends)
                        .padding(.top, 52)
                } else {
                    List {
                        trendsGraphs()
                    }
                }
            }
            .navigationTitle("Health Trends")
            .toolbar {
                TrendsToolbar()
            }
            .onAppear {
                // Temporary
                for _ in fetchedItems {
//                    self.viewModel.addData(data: [TrendsGraphDataItem(date: .now, value: 0.0)])
                }
            }
        }
    }
    
    @ViewBuilder func trendsGraphs() -> some View {
        ForEach(fetchedItems, id: \.hash) { item in
            Section {
                VStack {
                    
                    if viewModel.isLoading {
                        PlaceholderShimmerView()
                    } else {
                        
                        GraphView(viewModel: GraphViewModel(dataItems: item.healthData))
                            .padding(.top, 6)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name ?? "").font(.title3).bold()
                                
                                // TODO: store scientific name in CoreData
                                Text(item.name ?? "").italic()
                            }

                            Spacer()

                            VStack {
                                CircularProgressView(progress: 0.00, color: .gray, size: .small, showProgress: true)
                                    .frame(width: 42, height: 42)
                                Text("No Data")
                                    .font(.caption.bold())
                            }
                            .padding()
                        }
                    }
                   
                }
            }
        }
    }
    
    // Triggers refresh from CoreData
    func refreshFetchedItems() {
        let newItems = Array(fetchedItems)
        
        guard newItems.count == self.fetchedItems.count else { return }
        
//        self.viewModel.addData(data: [TrendsGraphDataItem(date: .now, value: 0)])
    }
}


extension TrendsView {
    struct TrendsToolbar: ToolbarContent {
        var body: some ToolbarContent {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        
                    } label: {
                        Image(systemName: ".")
                    }
                } label: {
                    Label("", systemImage: "")  // ellipsis.circle
                }
                .foregroundColor(.primary)
            }
        }
    }
}
