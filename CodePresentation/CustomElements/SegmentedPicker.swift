//
//  SelectionPocker.swift
//  CodePresentation
//
//  Created by Kirill Belashov on 19/9/23.
//

import SwiftUI

/// Этот кастомный элемент существует потому что стандартный `PickerView` в `SwiftUI` не имеет
/// нормальной кастомизации бэкграунда.
/// Даже если задать в `PickerView` цвет через модификатор `.background()` то на него
/// наложится `shadowLayer` сверху, который нельз убрать без костылей.
/// В определенный момент мне понадобился такой элемент в дизайн системе
/// и я решил сделать свой кастомный.
///
/// Может показаться, что использование `Mirror` здесь это оверхед и нужный
/// функционал можно реализовать проще, но выбранное решение дало возможность
/// обращаться к элементу через тот же интерфейс как у системного `PickerView`
///
/// Пример:
///
///     SegmentedPicker(selection: $selection) {
///         Text("first page")
///         .tag(0)
///         Text("second page")
///         .tag(1)
///     }
///
struct SegmentedPicker<Selection, Content>: View where Selection: Hashable, Content: View {
    
    @Namespace
    private var namespace
    
    @Binding
    private var selection: Selection
    
    private let contentMirror: Mirror
    private var elementsCount: Int = 0
    
    init(
        selection: Binding<Selection>,
        @ViewBuilder content: () -> Content
    ) {
        self._selection = selection
        self.contentMirror = Mirror(reflecting: content())
        
        if let reflectingValue = contentMirror.descendant("value") {
            self.elementsCount = Mirror(reflecting: reflectingValue).children.count
        }
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            Color.white
                .cornerRadius(12)
            
            HStack(alignment: .center) {
                ForEach(
                    0 ..< elementsCount,
                    id: \.self
                ) { index in
                    makeSegmentBy(index: index)
                }
            }
        }
        .frame(height: 36)
        .padding()
    }
    
    @ViewBuilder
    private func makeSegmentBy(index: Int) -> some View {
        
        if let tag = getTag(index),
           let text = getText(index) {
            
            Button {
                withAnimation(.linear(duration: 0.1)) {
                    selection = tag
                }
            } label: {
                Spacer()
                text
                    .foregroundColor(selection == tag ? .white : .gray)
                Spacer()
            }
            .background(
                Group {
                    if tag == selection {
                        Color.red
                            .frame(height: 28)
                            .cornerRadius(8)
                            .matchedGeometryEffect(id: "selector", in: namespace)
                            .padding(.horizontal, 4)
                    }
                },
                alignment: .center
            )
            .allowsHitTesting(selection == tag ? false : true)
        }
    }
    
    private func getTupleBlockMirror(_ index: Int) -> Mirror? {
        guard let tupleBlock = contentMirror.descendant("value", ".\(index)") else { return nil }
        
        return Mirror(reflecting: tupleBlock)
    }
    
    private func getText(_ index: Int) -> Text? {
        guard let text = getTupleBlockMirror(index)?.descendant("content") as? Text else { return nil }
        
        return text
    }
    
    private func getTag(_ index: Int) -> Selection? {
        guard let tag = getTupleBlockMirror(index)?.descendant("modifier", "value", "tagged") as? Selection else { return nil }
        
        return tag
    }
}
