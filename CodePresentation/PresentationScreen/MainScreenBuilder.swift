//
//  MainScreenBuilder.swift
//  CodePresentation
//
//  Created by Kirill Belashov on 19/9/23.
//

import SwiftUI

class MainScreenBuilder {
    static func build() -> some View {
        let viewModel = MainScreenViewModel()
        return MainScreen(viewModel: viewModel)
    }
}
