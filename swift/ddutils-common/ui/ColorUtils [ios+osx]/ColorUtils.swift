//
//  ColorUtils.swift
//  DesktopCountdowns
//
//  Created by Dominik Pich on 01.02.25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
typealias NativeColor = UIColor
#elseif canImport(AppKit)
import AppKit
typealias NativeColor = NSColor
#endif

// MARK: from hex
extension Color {
  // swiftlint:disable no_magic_numbers
  var hex: String {
    String(
      format: "#%02x%02x%02x%02x",
      Int(components.red * 255),
      Int(components.green * 255),
      Int(components.blue * 255),
      Int(components.opacity * 255)
    )
  }
  
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let alpha, red, green, blue: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
      
    default:
      (alpha, red, green, blue) = (1, 1, 1, 0)
    }
    
    self.init(
      .sRGB,
      red: Double(red) / 255,
      green: Double(green) / 255,
      blue: Double(blue) / 255,
      opacity: Double(alpha) / 255
    )
  }
  // swiftlint:enable no_magic_numbers
}

// MARK: tint
extension Color {
  func lighter(by percentage: CGFloat = 30.0) -> Color {
    self.adjust(by: abs(percentage) )
  }
  
  func darker(by percentage: CGFloat = 30.0) -> Color {
    self.adjust(by: -1 * abs(percentage) )
  }
  
  func adjust(by percentage: CGFloat = 30.0) -> Color {
    // swiftlint:disable no_magic_numbers
    return Color(
      red: min(components.red + percentage / 100, 1.0),
      green: min(components.green + percentage / 100, 1.0),
      blue: min(components.blue + percentage / 100, 1.0),
      opacity: components.opacity
    )
    // swiftlint:enable no_magic_numbers
  }
}

// MARK: get RGB components
extension Color {
  // swiftlint:disable large_tuple
  var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
  // swiftlint:enable large_tuple
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    NativeColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    return (red, green, blue, alpha)
  }
}

// MARK: RawRepresentable
extension Color: @retroactive RawRepresentable {
  public var rawValue: String {
    do {
      let data = try NSKeyedArchiver.archivedData(withRootObject: NativeColor(self), requiringSecureCoding: false) as Data
      return data.base64EncodedString()
    } catch {
      return ""
    }
  }

  public init?(rawValue: String) {
    guard let data = Data(base64Encoded: rawValue) else {
      self = .gray
      return
    }
    do {
      let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: NativeColor.self, from: data) ?? .gray
      self = Color(color)
    } catch {
      self = .gray
    }
  }
}
