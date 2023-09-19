//
//  ViewModel.swift
//  CodePresentation
//
//  Created by Kirill Belashov on 19/9/23.
//

import SwiftUI

final class MainScreenViewModel: ObservableObject {
    
    @Published
    var selection: SegmentedControlTags = .firstPage
    
    @Published
    var searchTerm = ""
    
    @Published
    var searchBarIsEditing = false
    
    func searchBarIsActive() -> Binding<Bool> {
        return Binding {
            return self.selection == .firstPage
        } set: { _ in }
    }
}

enum SegmentedControlTags: Hashable {
    case firstPage, secondPage
}
