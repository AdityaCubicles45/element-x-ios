//
// Copyright 2025 Element Creations Ltd.
// Copyright 2022-2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Compound
import SwiftUI

struct ServerSelectionScreen: View {
    @Bindable var context: ServerSelectionScreenViewModel.Context
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                    .padding(.top, 40)
                    .padding(.bottom, 36)
                
                serverList
            }
            .readableFrame()
            .padding(.horizontal, 16)
        }
        .background(Color.compound.bgCanvasDefault.ignoresSafeArea())
        .toolbar { toolbar }
        .alert(item: $context.alertInfo)
        .interactiveDismissDisabled()
    }
    
    /// The title, message and icon at the top of the screen.
    var header: some View {
        VStack(spacing: 32) {
            AuthenticationStartLogo(size: 80, hideBrandChrome: false, isOnGradient: false)
            
            VStack(spacing: 16) {
                Text(UntranslatedL10n.screenChangeServerTitle)
                    .font(.compound.headingLGBold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.compound.textPrimary)
                
                Text(UntranslatedL10n.screenChangeServerSubtitle)
                    .font(.compound.bodyLG)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.compound.textSecondary)
            }
        }
        .padding(.horizontal, 16)
    }
    
    /// The selectable server list.
    var serverList: some View {
        VStack(spacing: 16) {
            Button {
                context.homeserverAddress = "word.skin"
                submit()
            } label: {
                HStack(spacing: 16) {
                    // Document icon container
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.945, green: 0.949, blue: 0.965)) // #F1F2F6
                            .frame(width: 56, height: 56)
                        
                        CompoundIcon(\.public, size: .small, relativeTo: .compound.bodyLG) // Using \.public as a document/file-like icon if document is missing
                            .foregroundColor(.compound.iconPrimary)
                    }
                    
                    Text("word.skin")
                        .font(.compound.bodyLGSemibold)
                        .foregroundColor(.compound.textPrimary)
                    
                    Spacer()
                }
            }
            .accessibilityIdentifier(A11yIdentifiers.changeServerScreen.server)
        }
    }
    
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button { context.send(viewAction: .dismiss) } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.compound.textPrimary)
                    .font(.body.bold())
            }
            .accessibilityIdentifier(A11yIdentifiers.changeServerScreen.dismiss)
        }
    }
    
    /// Sends the `confirm` view action so long as the text field input is valid.
    func submit() {
        guard !context.viewState.hasValidationError else { return }
        context.send(viewAction: .confirm)
    }
}

// MARK: - Previews

/*
 /*
 struct ServerSelection_Previews: PreviewProvider, TestablePreview {
     static let matrixViewModel = makeViewModel(for: "https://matrix.org")
     static let emptyViewModel = makeViewModel(for: "")
     static let invalidViewModel = makeViewModel(for: "thisisbad")
    
     static var previews: some View {
         ElementNavigationStack {
             ServerSelectionScreen(context: matrixViewModel.context)
         }
        
         ElementNavigationStack {
             ServerSelectionScreen(context: emptyViewModel.context)
         }
        
         ElementNavigationStack {
             ServerSelectionScreen(context: invalidViewModel.context)
         }
         .snapshotPreferences(expect: invalidViewModel.context.observe(\.viewState.hasValidationError))
     }
    
     static func makeViewModel(for homeserverAddress: String) -> ServerSelectionScreenViewModel {
         let authenticationService = AuthenticationService.mock
        
         let viewModel = ServerSelectionScreenViewModel(authenticationService: authenticationService,
                                                        authenticationFlow: .login,
                                                        appSettings: ServiceLocator.shared.settings,
                                                        userIndicatorController: UserIndicatorControllerMock())
         viewModel.context.homeserverAddress = homeserverAddress
         if homeserverAddress == "thisisbad" {
             viewModel.context.send(viewAction: .confirm)
         }
         return viewModel
     }
 }
 */
 */
