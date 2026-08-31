//
// Copyright 2025 Element Creations Ltd.
// Copyright 2022-2025 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial.
// Please see LICENSE files in the repository root for full details.
//

import Combine
import SwiftUI

typealias SecureBackupRecoveryKeyScreenViewModelType = StateStoreViewModelV2<SecureBackupRecoveryKeyScreenViewState, SecureBackupRecoveryKeyScreenViewAction>

class SecureBackupRecoveryKeyScreenViewModel: SecureBackupRecoveryKeyScreenViewModelType, SecureBackupRecoveryKeyScreenViewModelProtocol {
    private let secureBackupController: SecureBackupControllerProtocol
    private let userIndicatorController: UserIndicatorControllerProtocol
    private let userID: String
    private let keychainController: KeychainControllerProtocol
    private let appSettings: AppSettings

    private var actionsSubject: PassthroughSubject<SecureBackupRecoveryKeyScreenViewModelAction, Never> = .init()
    var actions: AnyPublisher<SecureBackupRecoveryKeyScreenViewModelAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }

    init(secureBackupController: SecureBackupControllerProtocol,
         userIndicatorController: UserIndicatorControllerProtocol,
         isModallyPresented: Bool,
         userID: String,
         keychainController: KeychainControllerProtocol,
         appSettings: AppSettings) {
        self.secureBackupController = secureBackupController
        self.userIndicatorController = userIndicatorController
        self.userID = userID
        self.keychainController = keychainController
        self.appSettings = appSettings

        let mode = secureBackupController.recoveryState.value.viewMode
        super.init(initialViewState: .init(isModallyPresented: isModallyPresented,
                                           mode: mode,
                                           bindings: .init()))

        // Offer to auto-apply the on-device saved recovery key when the user is being asked to confirm it.
        if mode == .fixRecovery, keychainController.containsRecoveryKey(forUsername: userID) {
            state.canUseSavedRecoveryKey = true
        }
    }
    
    // MARK: - Public
    
    override func process(viewAction: SecureBackupRecoveryKeyScreenViewAction) {
        MXLog.info("View model: received view action: \(viewAction)")
        
        switch viewAction {
        case .generateKey:
            state.isGeneratingKey = true
            
            Task {
                switch await secureBackupController.generateRecoveryKey() {
                case .success(let key):
                    state.recoveryKey = key
                case .failure(let error):
                    MXLog.error("Failed generating recovery key with error: \(error)")
                    state.bindings.alertInfo = .init(id: .init())
                }
                
                state.isGeneratingKey = false
            }
        case .copyKey:
            UIPasteboard.general.string = state.recoveryKey
            userIndicatorController.submitIndicator(.init(title: "Copied recovery key"))
            state.doneButtonEnabled = true
        case .keySaved:
            state.doneButtonEnabled = true
        case .confirmKey:
            Task { await confirmRecoveryKey(state.bindings.confirmationRecoveryKey) }
        case .useSavedRecoveryKey:
            Task {
                showLoadingIndicator()
                defer { hideLoadingIndicator() }
                // Reading a biometric-protected keychain item triggers the Face/Touch ID prompt and blocks,
                // so it must run off the main actor.
                let savedKey = await Task.detached { [keychainController, userID] in
                    try? keychainController.recoveryKey(forUsername: userID, reason: L10n.commonRecoveryKey)
                }.value
                guard let savedKey, !savedKey.isEmpty else {
                    MXLog.warning("No saved recovery key available (removed or biometric auth cancelled).")
                    return
                }
                state.bindings.confirmationRecoveryKey = savedKey
                await confirmRecoveryKey(savedKey)
            }
        case .cancel:
            actionsSubject.send(.cancel)
        case .done:
            state.bindings.alertInfo = .init(id: .init(),
                                             title: L10n.screenRecoveryKeySetupConfirmationTitle,
                                             message: L10n.screenRecoveryKeySetupConfirmationDescription,
                                             primaryButton: .init(title: L10n.actionContinue) { [weak self] in
                                                 guard let self else { return }
                                                 // A freshly generated key: save it on-device if the user opted in.
                                                 saveRecoveryKeyIfEnabled(state.recoveryKey)
                                                 actionsSubject.send(.done(mode: state.mode))
                                             },
                                             secondaryButton: .init(title: L10n.actionCancel, role: .cancel, action: nil))
        }
    }

    private func confirmRecoveryKey(_ key: String) async {
        showLoadingIndicator()
        defer { hideLoadingIndicator() }

        switch await secureBackupController.confirmRecoveryKey(key) {
        case .success:
            // The key verified against the server: persist it on-device if the user opted in.
            saveRecoveryKeyIfEnabled(key)
            actionsSubject.send(.done(mode: state.mode))
        case .failure(let error):
            MXLog.error("Failed confirming recovery key with error: \(error)")
            state.bindings.alertInfo = .init(id: .init(),
                                             title: L10n.screenRecoveryKeyConfirmErrorTitle,
                                             message: L10n.screenRecoveryKeyConfirmErrorContent)
        }
    }

    /// Saves the recovery key to the device keychain (behind biometrics) when the opt-in setting is enabled.
    private func saveRecoveryKeyIfEnabled(_ key: String?) {
        guard appSettings.saveRecoveryKeyOnDevice, let key, !key.isEmpty else { return }
        do {
            try keychainController.setRecoveryKey(key, forUsername: userID)
            MXLog.info("Saved recovery key on device for auto-retrieval.")
        } catch {
            MXLog.error("Failed saving recovery key on device: \(error)")
        }
    }
    
    private static let loadingIndicatorIdentifier = "\(SecureBackupRecoveryKeyScreenViewModel.self)-Loading"
    
    private func showLoadingIndicator() {
        userIndicatorController.submitIndicator(UserIndicator(id: Self.loadingIndicatorIdentifier,
                                                              type: .modal,
                                                              title: L10n.commonLoading,
                                                              persistent: true))
    }
    
    private func hideLoadingIndicator() {
        userIndicatorController.retractIndicatorWithId(Self.loadingIndicatorIdentifier)
    }
}

extension SecureBackupRecoveryState {
    var viewMode: SecureBackupRecoveryKeyScreenViewMode {
        switch self {
        case .disabled:
            return .setupRecovery
        case .enabled:
            return .changeRecovery
        case .incomplete:
            return .fixRecovery
        default:
            return .unknown
        }
    }
}
