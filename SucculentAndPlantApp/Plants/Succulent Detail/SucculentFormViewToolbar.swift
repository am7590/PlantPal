//
//  SucculentFormViewToolbar.swift
//  SucculentAndPlantApp
//
//  Created by Alek Michelson on 5/27/24.
//

import SwiftUI

struct SucculentFormViewToolbar: ToolbarContent {
    @ObservedObject var viewModel: SuccuelentFormViewModel
    var grpcViewModel: GRPCViewModel
    var myImages: FetchedResults<Item>
    @Environment(\.dismiss) var dismiss
    
    @ToolbarContentBuilder
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(Color(uiColor: .systemOrange))
        }
        
        if viewModel.updating {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        viewModel.createItem(myImages: myImages)
                        grpcViewModel.removePlantEntry(with: viewModel.id ?? "0")
                        dismiss()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .tint(.primary)
                }
            }
        } else {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    let newItem = viewModel.updateItem(myImages: myImages)
                    dismiss()
                    grpcViewModel.createNewPlant(identifier: newItem.id ?? "69420", name: viewModel.name)
                    UserDefaults.standard.hasGeneratedUUID(for: viewModel.name, with: newItem.id!)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(uiColor: .systemGreen))
                .disabled(viewModel.incomplete)
            }
        }
    }
}
