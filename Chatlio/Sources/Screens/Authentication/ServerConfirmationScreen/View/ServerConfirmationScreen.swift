//
// Copyright 2025 Element Creations Ltd.
// Copyright 2022-2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Compound
import SwiftUI

struct ServerConfirmationScreen: View {
    @Bindable var context: ServerConfirmationScreenViewModel.Context
    
    private var backgroundColor: Color {
        .white
    }
    
    var body: some View {
        FullscreenDialog(topPadding: 32) {
            VStack(spacing: 32) {
                header
                mainContent
            }
        } bottomContent: {
            buttons
                .padding(.bottom, 16)
        }
        .background(backgroundColor.ignoresSafeArea())
        .alert(item: $context.alertInfo)
        .introspect(.window, on: .supportedVersions) { window in
            context.send(viewAction: .updateWindow(window))
        }
    }
    
    /// The main content of the view to be shown in a scroll view.
    var header: some View {
        VStack(spacing: 32) {
            // Branded logo container
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color(red: 0.945, green: 0.949, blue: 0.965)) // #F1F2F6
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 60, height: 60)
            }
            .padding(.top, 40)
            
            VStack(spacing: 16) {
                Text(context.viewState.title)
                    .font(.compound.headingLGBold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let message = context.viewState.message {
                    Text(message)
                        .font(.compound.bodyLG)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.compound.textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var mainContent: some View {
        if case .picker(let accountProviders) = context.viewState.mode {
            FakeInlinePicker(items: accountProviders,
                             icon: \.host,
                             selection: $context.pickerSelection)
                .accessibilityIdentifier(A11yIdentifiers.serverConfirmationScreen.serverPicker)
        }
    }
    
    /// The action buttons shown at the bottom of the view.
    var buttons: some View {
        VStack(spacing: 16) {
            Button { context.send(viewAction: .confirm) } label: {
                Text(L10n.actionContinue)
            }
            .buttonStyle(BlackButtonStyle())
            .accessibilityIdentifier(A11yIdentifiers.serverConfirmationScreen.continue)
            
            if case .confirmation = context.viewState.mode {
                Button { context.send(viewAction: .changeServer) } label: {
                    Text(UntranslatedL10n.screenOnboardingChangeServerIos)
                        .font(.compound.bodyLGSemibold)
                        .foregroundColor(.compound.textSecondary)
                        .padding(.vertical, 8)
                }
                .accessibilityIdentifier(A11yIdentifiers.serverConfirmationScreen.changeServer)
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct BlackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.compound.bodyLGSemibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.black)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

/// This is such a hack. I hate it!
/// But… We're not in a List/Form, the compound picker doesn't
/// support icons and this screen's design might change so 🤷‍♂️.
private struct FakeInlinePicker: View {
    let items: [String]
    let icon: KeyPath<CompoundIcons, Image>
    @Binding var selection: String?
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(items, id: \.self) { item in
                ListRow(label: .default(title: item, icon: icon),
                        kind: .selection(isSelected: selection == item) {
                            selection = item
                        })
                        .overlay(alignment: .bottom) {
                            if item != items.last {
                                Divider()
                                    .hidden()
                                    .overlay(Color.compound._borderInteractiveSecondaryAlpha)
                                    .padding(.leading, 54)
                            }
                        }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Previews

/*
struct ServerConfirmationScreen_Previews: PreviewProvider, TestablePreview {
    static let loginViewModel = makeViewModel(mode: .confirmation("matrix.org"), flow: .login)
    static let registerViewModel = makeViewModel(mode: .confirmation("matrix.org"), flow: .register)
    static let pickerViewModel = makeViewModel(mode: .picker(["dept1.company.com", "dept2.company.com", "dept3.company.com"]), flow: .login)
    
    static var previews: some View {
        ElementNavigationStack {
            ServerConfirmationScreen(context: loginViewModel.context)
                .toolbar(.visible, for: .navigationBar)
        }
        .previewDisplayName("Login")
        
        ElementNavigationStack {
            ServerConfirmationScreen(context: registerViewModel.context)
                .toolbar(.visible, for: .navigationBar)
        }
        .previewDisplayName("Register")
        
        ElementNavigationStack {
            ServerConfirmationScreen(context: pickerViewModel.context)
                .toolbar(.visible, for: .navigationBar)
        }
        .previewDisplayName("Picker")
    }
    
    static func makeViewModel(mode: ServerConfirmationScreenMode, flow: AuthenticationFlow) -> ServerConfirmationScreenViewModel {
        ServerConfirmationScreenViewModel(authenticationService: AuthenticationService.mock,
                                          mode: mode,
                                          authenticationFlow: flow,
                                          appSettings: ServiceLocator.shared.settings,
                                          userIndicatorController: UserIndicatorControllerMock())
    }
}
*/
