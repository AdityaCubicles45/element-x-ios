//
// Copyright 2025 Element Creations Ltd.
// Copyright 2023-2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import SwiftUI

/// The app's logo styled to fit on various launch pages.
struct AuthenticationStartLogo: View {
    /// Set to specify a custom size for the Logo, otherwise the default size of 158pt will be used.
    var size: CGFloat?
    /// Set to `true` to skip the brand chrome.
    let hideBrandChrome: Bool
    /// Set to `true` when using on top of `Asset.Images.launchBackground`.
    let isOnGradient: Bool
    
    private let appLogoImage = Image(asset: Asset.Images.appLogo)
    
    struct SizeMetrics {
        let scale: CGFloat
        let imageSize: CGFloat
    }
    
    private var sizeMetrics: SizeMetrics? {
        size.map { customSize in
            let scale = customSize / 158
            return SizeMetrics(scale: scale,
                               imageSize: hideBrandChrome ? customSize : 110 * scale)
        }
    }
    
    var body: some View {
        if let sizeMetrics {
            appLogoImage
                .resizable()
                .frame(width: sizeMetrics.imageSize, height: sizeMetrics.imageSize)
                .modifier(AuthenticationBrandLogoModifier(scale: sizeMetrics.scale,
                                                          hideBrandChrome: hideBrandChrome,
                                                          isOnGradient: isOnGradient))
        } else {
            appLogoImage
                .modifier(AuthenticationBrandLogoModifier(scale: 1,
                                                          hideBrandChrome: hideBrandChrome,
                                                          isOnGradient: isOnGradient))
        }
    }
}

/// Applies the brand chrome styling (rounded card with shadows and border) to any image,
/// as seen on the authentication start screen.
private struct AuthenticationBrandLogoModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    /// Scale factor relative to the original 158pt design.
    let scale: CGFloat
    /// Set to `true` to skip the brand chrome.
    let hideBrandChrome: Bool
    /// Set to `true` when using on top of `Asset.Images.launchBackground`.
    let isOnGradient: Bool
    
    private let outerShapeShadowColor = Color(red: 0.11, green: 0.11, blue: 0.13)
    private var isLight: Bool {
        colorScheme == .light
    }

    /// Extra padding needed to avoid cropping the shadows.
    private var extra: CGFloat {
        64 * scale
    }

    /// The shape that the logo is composed on top of.
    private var outerShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 44 * scale)
    }
    
    func body(content: Content) -> some View {
        if hideBrandChrome {
            content
        } else {
            styledContent(content)
        }
    }
    
    private func styledContent(_ content: Content) -> some View {
        content
            .padding(32 * scale)
            .background(Color(red: 0xF1 / 255.0, green: 0xF2 / 255.0, blue: 0xF6 / 255.0))
            .clipShape(RoundedRectangle(cornerRadius: 32 * scale))
            .accessibilityHidden(true)
    }
}

#Preview {
    VStack(spacing: 0) {
        HStack(spacing: 0) {
            AuthenticationStartLogo(hideBrandChrome: false, isOnGradient: false)
                .padding()
            AuthenticationStartLogo(hideBrandChrome: false, isOnGradient: true)
                .padding()
                .background {
                    AuthenticationStartScreenBackgroundImage().offset(y: 70)
                }
                .clipped()
        }
        .background(.compound.bgCanvasDefault)
        
        HStack(spacing: 0) {
            AuthenticationStartLogo(hideBrandChrome: false, isOnGradient: false)
                .padding()
            AuthenticationStartLogo(hideBrandChrome: false, isOnGradient: true)
                .padding()
                .background {
                    AuthenticationStartScreenBackgroundImage().offset(y: 70)
                }
                .clipped()
        }
        .background(.compound.bgCanvasDefault)
        .colorScheme(.dark)
        
        HStack(spacing: 0) {
            AuthenticationStartLogo(size: 54, hideBrandChrome: false, isOnGradient: false)
                .padding()
                .background(.compound.bgCanvasDefault)
            AuthenticationStartLogo(size: 54, hideBrandChrome: false, isOnGradient: false)
                .padding()
                .background(.compound.bgCanvasDefault)
                .colorScheme(.dark)
        }
        .padding(.top)
    }
}
