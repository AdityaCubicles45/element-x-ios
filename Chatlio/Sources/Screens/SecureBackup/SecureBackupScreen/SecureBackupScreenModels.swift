//
// Copyright 2025 Element Creations Ltd.
// Copyright 2022-2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Foundation

enum SecureBackupScreenViewModelAction {
    case manageRecoveryKey
    case disableKeyBackup
}

struct SecureBackupScreenViewState: BindableState {
    let chatBackupDetailsURL: URL
    var recoveryState = SecureBackupRecoveryState.unknown
    var keyBackupState = SecureBackupKeyBackupState.unknown
    var bindings: SecureBackupScreenViewStateBindings
    
    var keyStorageToggleDescription: String? {
        keyBackupState.keyStorageToggleState ? nil : L10n.screenChatBackupKeyStorageDisabledError
    }
}

struct SecureBackupScreenViewStateBindings {
    var keyStorageEnabled: Bool
    /// Opt-in: save the recovery key in the device keychain (behind Face/Touch ID) for auto-retrieval on sign-in.
    var saveRecoveryKeyOnDevice: Bool
    var alertInfo: AlertInfo<UUID>?
}

enum SecureBackupScreenViewAction {
    case recoveryKey
    case keyStorageToggled(Bool)
    case saveRecoveryKeyOnDeviceToggled(Bool)
}
