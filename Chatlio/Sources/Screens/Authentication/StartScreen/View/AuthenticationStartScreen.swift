//
// Copyright 2025 Element Creations Ltd.
// Copyright 2022-2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Compound
import SwiftUI

/// The screen shown at the beginning of the onboarding flow.
struct AuthenticationStartScreen: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    @Bindable var context: AuthenticationStartScreenViewModel.Context
    
    var body: some View {
        // This view uses a GeometryReader instead of FullscreenDialog so its content takes the full
        // height available (after taking the buttons out of the equation) in order for the logo
        // and title to appear vertically centred and equally spaced within this content area.
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                        .frame(height: UIConstants.spacerHeight(in: geometry))
                    
                    content
                        .frame(width: geometry.size.width)
                        .accessibilityIdentifier(A11yIdentifiers.authenticationStartScreen.hidden)
                    
                    buttons
                        .frame(width: geometry.size.width)
                        .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 0 : 16)
                        .padding(.top, 8)
                    
                    Spacer()
                        .frame(height: UIConstants.spacerHeight(in: geometry))
                }
                .frame(minHeight: geometry.size.height)
            }
            .scrollBounceBehavior(.basedOnSize)
            .overlay(alignment: .bottomTrailing) {
                CompoundIcon(\.chevronRight)
                    .foregroundColor(.compound.textActionPrimary)
                    .padding()
                    .offset(y: -geometry.safeAreaInsets.bottom)
            }
        }
        .navigationBarHidden(true)
        .background {
            AuthenticationStartScreenBackgroundImage()
        }
        .alert(item: $context.alertInfo)
        .introspect(.window, on: .supportedVersions) { window in
            context.send(viewAction: .updateWindow(window))
        }
    }
    
    var content: some View {
        VStack(spacing: 0) {
            Spacer()
            
            if verticalSizeClass == .regular {
                Spacer()
                
                AuthenticationStartLogo(hideBrandChrome: context.viewState.hideBrandChrome,
                                        isOnGradient: !context.viewState.hideBrandChrome)
            }
            
            Spacer()
            
            if !context.viewState.hideBrandChrome {
                VStack(spacing: 8) {
                    Text(InfoPlistReader.main.productionAppName)
                        .font(.compound.headingLGBold)
                        .foregroundColor(.compound.textPrimary)
                        .multilineTextAlignment(.center)
                    Text(UntranslatedL10n.screenOnboardingWelcomeMessageChatlio)
                        .font(.compound.bodyLG)
                        .foregroundColor(.compound.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.bottom)
        .padding(.horizontal, 16)
        .readableFrame()
    }
    
    /// The main action buttons.
    var buttons: some View {
        VStack(spacing: 16) {
            if context.viewState.showQRCodeLoginButton {
                Button { context.send(viewAction: .loginWithQR) } label: {
                    Label(L10n.screenOnboardingSignInWithQrCode, icon: \.qrCode)
                }
                .buttonStyle(BlackButtonStyle())
                .accessibilityIdentifier(A11yIdentifiers.authenticationStartScreen.signInWithQr)
            }
            
            Button { context.send(viewAction: .login) } label: {
                Text(context.viewState.loginButtonTitle)
            }
            .buttonStyle(BlackButtonStyle())
            .accessibilityIdentifier(A11yIdentifiers.authenticationStartScreen.signIn)
            
            if context.viewState.showCreateAccountButton {
                HStack(spacing: 4) {
                    Text(UntranslatedL10n.screenOnboardingSignupQuestion)
                        .foregroundColor(.compound.textSecondary)
                    Button { context.send(viewAction: .register) } label: {
                        Text(UntranslatedL10n.screenOnboardingSignupLink)
                            .foregroundColor(.compound.textActionPrimary)
                            .underline()
                    }
                }
                .font(.compound.bodyMD)
                .padding(.top, 8)
            }
            
            versionText
                .font(.compound.bodySMSemibold)
                .foregroundColor(.compound.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .onTapGesture(count: 7) {
                    context.send(viewAction: .reportProblem)
                }
                .accessibilityIdentifier(A11yIdentifiers.authenticationStartScreen.appVersion)
        }
        .padding(.horizontal, verticalSizeClass == .compact ? 128 : 24)
        .readableFrame()
    }
    
    var versionText: Text {
        // Let's not deal with snapshotting a changing version string.
        let shortVersionString = ProcessInfo.isRunningTests ? "0.0.0" : InfoPlistReader.main.bundleShortVersionString
        return Text("VERSION \(shortVersionString) (SECURE BUILD)".uppercased())
    }
}

private struct BlackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.compound.bodyLGSemibold)
            .foregroundColor(.compound.bgCanvasDefault)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.compound.textPrimary)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

// MARK: - Previews

/*
 struct AuthenticationStartScreen_Previews: PreviewProvider, TestablePreview {
     static let viewModel = makeViewModel()
     static let provisionedViewModel = makeViewModel(provisionedServerName: "example.com")
    
     static var previews: some View {
         AuthenticationStartScreen(context: viewModel.context)
             .previewDisplayName("Default")
         AuthenticationStartScreen(context: provisionedViewModel.context)
             .previewDisplayName("Provisioned")
     }
    
     static func makeViewModel(provisionedServerName: String? = nil) -> AuthenticationStartScreenViewModel {
         AuthenticationStartScreenViewModel(authenticationService: AuthenticationService.mock,
                                            provisioningParameters: provisionedServerName.map { .init(accountProvider: $0, loginHint: nil) },
                                            isBugReportServiceEnabled: true,
                                            appSettings: ServiceLocator.shared.settings,
                                            userIndicatorController: UserIndicatorControllerMock())
     }
 }
 */
