// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// TuneForest
  internal static let appName = L10n.tr("Localizable", "app_name", fallback: "TuneForest")
  /// Audio from Video
  internal static let fromVideo = L10n.tr("Localizable", "from_video", fallback: "Audio from Video")
  /// Import files
  internal static let importFiles = L10n.tr("Localizable", "import_files", fallback: "Import files")
  /// Live Wallpaper Maker
  internal static let liveWallpaperMaker = L10n.tr("Localizable", "live_wallpaper_maker", fallback: "Live Wallpaper Maker")
  /// Localizable.strings
  ///   RingtoneForest
  /// 
  ///   Created by Thu Trương on 13/06/2023.
  internal static let maker = L10n.tr("Localizable", "maker", fallback: "Maker")
  /// Media
  internal static let media = L10n.tr("Localizable", "media", fallback: "Media")
  /// My tone
  internal static let myTone = L10n.tr("Localizable", "my_tone", fallback: "My tone")
  /// Record Audio
  internal static let recordAudio = L10n.tr("Localizable", "record_audio", fallback: "Record Audio")
  /// Setting
  internal static let setting = L10n.tr("Localizable", "setting", fallback: "Setting")
  /// Wallpaper
  internal static let wallpaper = L10n.tr("Localizable", "wallpaper", fallback: "Wallpaper")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
