// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum UntranslatedL10n {
  /// Chatlio on your other device
  internal static var a11yQrCodeLoginElementXOnDevice: String { return UntranslatedL10n.tr("Untranslated", "a11y_qr_code_login_element_x_on_device") }
  /// Start voice call
  internal static var a11yStartVoiceCall: String { return UntranslatedL10n.tr("Untranslated", "a11y_start_voice_call") }
  /// Video call
  internal static var actionVideoCall: String { return UntranslatedL10n.tr("Untranslated", "action_video_call") }
  /// Voice call
  internal static var actionVoiceCall: String { return UntranslatedL10n.tr("Untranslated", "action_voice_call") }
  /// Calls coming soon
  internal static var commonCallsComingSoon: String { return UntranslatedL10n.tr("Untranslated", "common_calls_coming_soon") }
  /// Video call
  internal static var commonVideoCall: String { return UntranslatedL10n.tr("Untranslated", "common_video_call") }
  /// Voice call
  internal static var commonVoiceCall: String { return UntranslatedL10n.tr("Untranslated", "common_voice_call") }
  /// To take pictures or videos and send them as a message Chatlio needs access to the camera.
  internal static var nsCameraUsageDescription: String { return UntranslatedL10n.tr("Untranslated", "NSCameraUsageDescription") }
  /// Grant location access so that Chatlio can share your location.
  internal static var nsLocationWhenInUseUsageDescription: String { return UntranslatedL10n.tr("Untranslated", "NSLocationWhenInUseUsageDescription") }
  /// To record and send messages with audio, Chatlio needs to access the microphone.
  internal static var nsMicrophoneUsageDescription: String { return UntranslatedL10n.tr("Untranslated", "NSMicrophoneUsageDescription") }
  /// Use a different account provider, such as your own private server or a work account.
  internal static var screenChangeServerSubtitle: String { return UntranslatedL10n.tr("Untranslated", "screen_change_server_subtitle") }
  /// Change account provider
  internal static var screenChangeServerTitle: String { return UntranslatedL10n.tr("Untranslated", "screen_change_server_title") }
  /// Calls
  internal static var screenHomeTabCalls: String { return UntranslatedL10n.tr("Untranslated", "screen_home_tab_calls") }
  /// Chats
  internal static var screenHomeTabChats: String { return UntranslatedL10n.tr("Untranslated", "screen_home_tab_chats") }
  /// Groups
  internal static var screenHomeTabGroups: String { return UntranslatedL10n.tr("Untranslated", "screen_home_tab_groups") }
  /// Change provider >
  internal static var screenOnboardingChangeServerIos: String { return UntranslatedL10n.tr("Untranslated", "screen_onboarding_change_server_ios") }
  /// Create one
  internal static var screenOnboardingSignupLink: String { return UntranslatedL10n.tr("Untranslated", "screen_onboarding_signup_link") }
  /// Don't have an account?
  internal static var screenOnboardingSignupQuestion: String { return UntranslatedL10n.tr("Untranslated", "screen_onboarding_signup_question") }
  /// Secure communication in its most essential form.
  internal static var screenOnboardingWelcomeMessageChatlio: String { return UntranslatedL10n.tr("Untranslated", "screen_onboarding_welcome_message_chatlio") }
  /// Unsupported call. Ask if the caller can use the new Chatlio app.
  internal static var screenRoomTimelineLegacyCall: String { return UntranslatedL10n.tr("Untranslated", "screen_room_timeline_legacy_call") }
  /// A private server for Chatlio employees.
  internal static var screenServerConfirmationMessageLoginElementDotIo: String { return UntranslatedL10n.tr("Untranslated", "screen_server_confirmation_message_login_element_dot_io") }
  /// Clear all data currently stored on this device?
  /// Sign in again to access your account data and messages.
  internal static var softLogoutClearDataDialogContent: String { return UntranslatedL10n.tr("Untranslated", "soft_logout_clear_data_dialog_content") }
  /// Clear data
  internal static var softLogoutClearDataDialogTitle: String { return UntranslatedL10n.tr("Untranslated", "soft_logout_clear_data_dialog_title") }
  /// Warning: Your personal data (including encryption keys) is still stored on this device.
  /// 
  /// Clear it if you’re finished using this device, or want to sign in to another account.
  internal static var softLogoutClearDataNotice: String { return UntranslatedL10n.tr("Untranslated", "soft_logout_clear_data_notice") }
  /// Clear all data
  internal static var softLogoutClearDataSubmit: String { return UntranslatedL10n.tr("Untranslated", "soft_logout_clear_data_submit") }
  /// Clear personal data
  internal static var softLogoutClearDataTitle: String { return UntranslatedL10n.tr("Untranslated", "soft_logout_clear_data_title") }
  /// Sign in to recover encryption keys stored exclusively on this device. You need them to read all of your secure messages on any device.
  internal static var softLogoutSigninE2eWarningNotice: String { return UntranslatedL10n.tr("Untranslated", "soft_logout_signin_e2e_warning_notice") }
  /// Your homeserver (%1$s) admin has signed you out of your account %2$s (%3$s).
  internal static func softLogoutSigninNotice(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>, _ p3: UnsafePointer<CChar>) -> String {
    return UntranslatedL10n.tr("Untranslated", "soft_logout_signin_notice", p1, p2, p3)
  }
  /// Sign in
  internal static var softLogoutSigninTitle: String { return UntranslatedL10n.tr("Untranslated", "soft_logout_signin_title") }
  /// Untranslated
  internal static var untranslated: String { return UntranslatedL10n.tr("Untranslated", "untranslated") }
  /// Plural format key: "%#@VARIABLE@"
  internal static func untranslatedPlural(_ p1: Int) -> String {
    return UntranslatedL10n.tr("Untranslated", "untranslated_plural", p1)
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension UntranslatedL10n {
  static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // No need to check languages, we always default to en for untranslated strings
    guard let bundle = Bundle.lprojBundle(for: "en") else { return key }
    let format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
    return String(format: format, locale: Locale(identifier: "en"), arguments: args)
  }
}

// swiftlint:enable all
