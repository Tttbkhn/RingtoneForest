// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let icBack = ImageAsset(name: "ic_back")
    internal static let icClose = ImageAsset(name: "ic_close")
    internal static let icContactUs = ImageAsset(name: "ic_contact_us")
    internal static let icCrown = ImageAsset(name: "ic_crown")
    internal static let icCutter = ImageAsset(name: "ic_cutter")
    internal static let icCutterLeft = ImageAsset(name: "ic_cutter_left")
    internal static let icCutterRight = ImageAsset(name: "ic_cutter_right")
    internal static let icDelete = ImageAsset(name: "ic_delete")
    internal static let icDone = ImageAsset(name: "ic_done")
    internal static let icImportFile = ImageAsset(name: "ic_import_file")
    internal static let icInstallRingtone = ImageAsset(name: "ic_install_ringtone")
    internal static let icLiveWallpaper = ImageAsset(name: "ic_live_wallpaper")
    internal static let icMakerSelected = ImageAsset(name: "ic_maker_selected")
    internal static let icMakerUnselected = ImageAsset(name: "ic_maker_unselected")
    internal static let icMytonesSelected = ImageAsset(name: "ic_mytones_selected")
    internal static let icMytonesUnselected = ImageAsset(name: "ic_mytones_unselected")
    internal static let icPauseRecord = ImageAsset(name: "ic_pause_record")
    internal static let icPauseWhite = ImageAsset(name: "ic_pause_white")
    internal static let icPlayRecord = ImageAsset(name: "ic_play_record")
    internal static let icPlayWhite = ImageAsset(name: "ic_play_white")
    internal static let icPremiumCrown = ImageAsset(name: "ic_premium_crown")
    internal static let icPrivacy = ImageAsset(name: "ic_privacy")
    internal static let icQuestion = ImageAsset(name: "ic_question")
    internal static let icRecord = ImageAsset(name: "ic_record")
    internal static let icRename = ImageAsset(name: "ic_rename")
    internal static let icRingtoneGreen = ImageAsset(name: "ic_ringtone_green")
    internal static let icSetRingtone = ImageAsset(name: "ic_set_ringtone")
    internal static let icSettingSelected = ImageAsset(name: "ic_setting_selected")
    internal static let icSettingUnselected = ImageAsset(name: "ic_setting_unselected")
    internal static let icShare = ImageAsset(name: "ic_share")
    internal static let icSmallCrown = ImageAsset(name: "ic_small_crown")
    internal static let icStartRecord = ImageAsset(name: "ic_start_record")
    internal static let icStopRecord = ImageAsset(name: "ic_stop_record")
    internal static let icTerms = ImageAsset(name: "ic_terms")
    internal static let icTunes = ImageAsset(name: "ic_tunes")
    internal static let icVideo = ImageAsset(name: "ic_video")
    internal static let icVideoFromMedia = ImageAsset(name: "ic_video_from_media")
    internal static let icWallpaperSelected = ImageAsset(name: "ic_wallpaper_selected")
    internal static let icWallpaperUnselected = ImageAsset(name: "ic_wallpaper_unselected")
    internal static let imgBackground = ImageAsset(name: "img_background")
    internal static let imgNoRingtones = ImageAsset(name: "img_no_ringtones")
    internal static let imgPro = ImageAsset(name: "img_pro")
  }
  internal enum Colors {
    internal static let colorBG16181C = ColorAsset(name: "ColorBG#16181C")
    internal static let colorBG = ColorAsset(name: "ColorBG")
    internal static let colorBlack = ColorAsset(name: "ColorBlack")
    internal static let colorBlue007AFF = ColorAsset(name: "ColorBlue007AFF")
    internal static let colorBlueGrad1273437 = ColorAsset(name: "ColorBlueGrad1#273437")
    internal static let colorBlueGrad2202329 = ColorAsset(name: "ColorBlueGrad2#202329")
    internal static let colorDivider707070 = ColorAsset(name: "ColorDivider707070")
    internal static let colorGray83868A = ColorAsset(name: "ColorGray#83868A")
    internal static let colorGrayBCBCBC = ColorAsset(name: "ColorGrayBCBCBC")
    internal static let colorGrayCDD2D8 = ColorAsset(name: "ColorGrayCDD2D8")
    internal static let colorGrayCFCFCF = ColorAsset(name: "ColorGrayCFCFCF")
    internal static let colorGrayF2F2F2F80 = ColorAsset(name: "ColorGrayF2F2F2F80")
    internal static let colorGreen69BE15 = ColorAsset(name: "ColorGreen69BE15")
    internal static let colorGreen69BE15O15 = ColorAsset(name: "ColorGreen69BE15O15")
    internal static let colorGreenGrad12C3727 = ColorAsset(name: "ColorGreenGrad1#2C3727")
    internal static let colorPinkGrad136242B = ColorAsset(name: "ColorPinkGrad1#36242B")
    internal static let colorTabBG202329 = ColorAsset(name: "ColorTabBG#202329")
    internal static let colorWhite = ColorAsset(name: "ColorWhite")
    internal static let colorWhite70 = ColorAsset(name: "ColorWhite70")
    internal static let colorWhite90 = ColorAsset(name: "ColorWhite90")
    internal static let colorYellowFFEE0A = ColorAsset(name: "ColorYellowFFEE0A")
    internal static let colorYellowGrad1312E25 = ColorAsset(name: "ColorYellowGrad1#312E25")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

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
