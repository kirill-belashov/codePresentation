//
//  UIApplication+Extensions.swift
//  CodePresentation
//
//  Created by Kirill Belashov on 19/9/23.
//

import SwiftUI

public extension View {
    func endEditing(_ force: Bool = true) {
        UIApplication.shared.windows.forEach { $0.endEditing(force) }
    }
}
