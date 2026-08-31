//
// Copyright 2025 Element Creations Ltd.
// Copyright 2022-2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Foundation
import MatrixRustSDK

struct KeychainCredentials {
    let userID: String
    let restorationToken: RestorationToken
}

// sourcery: AutoMockable
protocol KeychainControllerProtocol: ClientSessionDelegate {
    // MARK: Restoration Tokens
    
    func setRestorationToken(_ restorationToken: RestorationToken, forUsername: String)
    func restorationTokens() -> [KeychainCredentials]
    func removeRestorationTokenForUsername(_ username: String)
    func removeAllRestorationTokens()
    
    // MARK: App Secrets
    
    /// Whether or not an App Lock PIN code has been set.
    func containsPINCode() throws -> Bool
    /// Sets a new PIN code for App Lock.
    func setPINCode(_ pinCode: String) throws
    /// The PIN code required to unlock the app.
    func pinCode() -> String?
    /// Removes the App Lock PIN code.
    func removePINCode()
    /// Whether or not PIN code biometric state has been set.
    func containsPINCodeBiometricState() -> Bool
    /// Sets the PIN code biometric state for App Lock.
    func setPINCodeBiometricState(_ state: Data) throws
    /// The PIN code biometric state required to use Touch/Face ID to unlock the app.
    func pinCodeBiometricState() -> Data?
    /// Removes the App Lock PIN code biometric state.
    func removePINCodeBiometricState()

    // MARK: Recovery Key (opt-in, biometric-gated)

    /// Whether a recovery key has been saved on this device for the given user. Does not trigger biometrics.
    func containsRecoveryKey(forUsername username: String) -> Bool
    /// Saves the recovery key for the given user, protected behind device biometrics (Face/Touch ID),
    /// stored only on this device and never synced to iCloud Keychain or device backups.
    func setRecoveryKey(_ recoveryKey: String, forUsername username: String) throws
    /// Retrieves the saved recovery key for the given user. Triggers a biometric prompt showing `reason`.
    /// Returns nil if none is stored. MUST be called off the main thread (the prompt blocks).
    func recoveryKey(forUsername username: String, reason: String) throws -> String?
    /// Removes the saved recovery key for the given user.
    func removeRecoveryKey(forUsername username: String)
}
