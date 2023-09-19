//
//  ContentView.swift
//  CodePresentation
//
//  Created by Kirill Belashov on 19/9/23.
//

import SwiftUI

struct MainScreen: View {
    
    @ObservedObject
    var viewModel: MainScreenViewModel
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            SegmentedPicker(selection: $viewModel.selection) {
                Text("first page")
                    .tag(SegmentedControlTags.firstPage)
                Text("second page")
                    .tag(SegmentedControlTags.secondPage)
            }
            
            DisablableSearchBar(
                placeholder: "Что хотите найти?",
                text: $viewModel.searchTerm,
                isEditing: $viewModel.searchBarIsEditing,
                isActive: viewModel.searchBarIsActive().animation()
            )
            
            Spacer()
        }
        .padding()
        .background(
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
                .onTapGesture {
                    endEditing()
                    withAnimation {
                        viewModel.searchBarIsEditing = false
                    }
                    
                }
        )
    }
}
