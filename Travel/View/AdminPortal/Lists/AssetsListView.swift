//
//  AssetsListView.swift
//  Travel
//
//  Created by Gaurav Bhambhani on 11/16/24.
//

import SwiftUI

struct AssetsListView: View {

    @ObservedObject private var assetViewModel = AssetViewModel()

    @State private var showAddAssetSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(assetViewModel.assets) { asset in
                    NavigationLink(asset.type) {
                        AssetDetailsView(asset: asset)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let assetToDelete = assetViewModel.assets[index]
                        assetViewModel.deleteAsset(assetToDelete)
                    }
                }
            }
            .navigationTitle("Assets")
            .toolbar {
                Button("Add") {
                    showAddAssetSheet = true
                }
            }
            .sheet(isPresented: $showAddAssetSheet, onDismiss: {
                assetViewModel.fetchAssets()
            }) {
                AddAssetDetailsView(assetViewModel: assetViewModel)
            }
        }
    }
}

#Preview {
    AssetsListView()
}
