//
//  DisablebleSearchBar.swift
//  CodePresentation
//
//  Created by Kirill Belashov on 19/9/23.
//

import SwiftUI

/// Это кастомный `SearchBar` c возможностью очищать текст и отменять поиск,
/// и так же возможностью становиться неактивным.
///
/// Пример:
///
///     DisablableSearchBar(
///         placeholder: "Что хотите найти?",
///         text: $searchTerm,
///         isEditing: $searchBarIsEditing,
///         isActive: $searchBarIsActive
///     )
///
struct DisablableSearchBar: View {
    
    @Binding
    private var isEditing: Bool
    
    @Binding
    private var isActive: Bool
    
    @Binding
    private var text: String
    
    private let placeholder: String
        
    public init(
        placeholder: String,
        text: Binding<String>,
        isEditing: Binding<Bool>,
        isActive: Binding<Bool>
    ) {
        self._text = text
        self._isEditing = isEditing
        self._isActive = isActive
        self.placeholder = placeholder
    }
    
    public var body: some View {
        HStack {
            searchField
            
            if isEditing {
                CancelButton(searchText: $text) {
                    hide()
                }
            }
        }
        .allowsHitTesting(isActive)
        .opacity(isActive ? 1 : 0.4)
        .onChange(of: isActive) { newValue in
            if !newValue {
                hide()
            }
        }
    }
    
    var searchField: some View {
        ZStack (alignment: .trailing) {
            HStack {
                Image(systemName: "magnifyingglass")
                
                ZStack (alignment: .leading){
                    
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.secondary)
                    }
                    
                    TextField("", text: $text) { _ in
                        withAnimation {
                            self.isEditing = true
                        }
                    }
                    .accentColor(.black)
                    .onTapGesture {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    }
                }
                
                Spacer()
                
                if !text.isEmpty {
                    Button {
                        text.removeAll()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, -8)
                }
            }
            .frame(height: 46)
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    private func hide() {
            text.removeAll()
            endEditing()
        withAnimation {
            self.isEditing = false
        }
    }
}

fileprivate struct CancelButton: View {
    
    @Binding
    var searchText: String
    
    private let hideAction: () -> Void
    
    init(
        searchText: Binding<String>,
        hideAction: @escaping ()-> Void
    ) {
        _searchText = searchText
        self.hideAction = hideAction
    }

    var body: some View {
        Button {
            hideAction()
            endEditing()
            searchText.removeAll()
        } label: {
            Text("Отмена")
                .foregroundColor(.black)
        }
    }
}
