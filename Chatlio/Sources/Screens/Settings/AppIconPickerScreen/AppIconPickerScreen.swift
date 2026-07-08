//
// Copyright 2025 Element Creations Ltd.
// Copyright 2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Compound
import SwiftUI
import UIKit

/// A self-contained picker for the app launcher icon. Uses the system alternate-icon
/// API; the alternate icon sets (MidnightIcon/SunsetIcon/ForestIcon) are bundled via
/// the ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS build setting.
struct AppIconPickerScreen: View {
    @Environment(\.dismiss) private var dismiss

    private struct Option: Identifiable {
        let id: String
        /// The alternate icon set name, or `nil` for the primary (Indigo) icon.
        let alternateName: String?
        let title: String
    }

    private let options: [Option] = [
        Option(id: "default", alternateName: nil, title: "Chatlio"),
        Option(id: "WeatherIcon", alternateName: "WeatherIcon", title: "Weather"),
        Option(id: "MagnifierIcon", alternateName: "MagnifierIcon", title: "Magnifier"),
        Option(id: "PreviewIcon", alternateName: "PreviewIcon", title: "Preview"),
        Option(id: "CameraIcon", alternateName: "CameraIcon", title: "Camera")
    ]

    @State private var currentIconName: String? = UIApplication.shared.alternateIconName

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ForEach(options) { option in
                        ListRow(label: .default(title: option.title, icon: \.image),
                                kind: .selection(isSelected: currentIconName == option.alternateName) {
                                    setIcon(option.alternateName)
                                })
                    }
                }
            }
            .compoundList()
            .navigationTitle("App icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.actionDone) { dismiss() }
                }
            }
        }
    }

    private func setIcon(_ name: String?) {
        guard UIApplication.shared.alternateIconName != name else { return }
        UIApplication.shared.setAlternateIconName(name) { error in
            if error == nil {
                currentIconName = name
            }
        }
    }
}
