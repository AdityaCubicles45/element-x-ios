//
// Copyright 2025 Element Creations Ltd.
// Copyright 2024-2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import SwiftUI

struct RoomListFilterView: View {
    let filter: RoomListFilter
    @Binding var isActive: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Toggle(isOn: $isActive) {
            Text(filter.localizedName)
        }
        .toggleStyle(FilterToggleStyle(colorScheme: colorScheme))
    }
}

private struct FilterToggleStyle: ToggleStyle {
    // Dark mode only: unselected chips need a lighter fill and a stronger border
    // so they are clearly visible on a black background. Light mode is unchanged.
    let colorScheme: ColorScheme
    private var isDark: Bool {
        colorScheme == .dark
    }

    private func strokeColor(isOn: Bool) -> Color {
        if isOn { return .compound.bgActionPrimaryRest }
        return isDark ? .compound.borderInteractivePrimary : .compound.borderInteractiveSecondary
    }

    private func backgroundColor(isOn: Bool) -> Color {
        if isOn { return .compound.bgActionPrimaryRest }
        return isDark ? .compound.bgSubtleSecondary : .compound.bgSubtlePrimary
    }

    private func foregroundColor(isOn: Bool) -> Color {
        isOn ? .white : .compound.textPrimary
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let shape = RoundedRectangle(cornerRadius: 20)
        configuration.label
            .font(.compound.bodyMD)
            .foregroundColor(foregroundColor(isOn: configuration.isOn))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(shape.fill(backgroundColor(isOn: configuration.isOn)))
            .overlay {
                shape
                    .inset(by: 0.5)
                    .stroke(strokeColor(isOn: configuration.isOn))
            }
            .drawingGroup()
            // The button breaks the animation for some reason, so better to use the label directly with an onTapGesture
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

// MARK: - Previews

/*
 struct RoomListFilterView_Previews: PreviewProvider, TestablePreview {
     static var previews: some View {
         RoomListFilterView(filter: .people, isActive: .constant(false))
         RoomListFilterView(filter: .people, isActive: .constant(true))
     }
 }
 */
