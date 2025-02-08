//
//  LaunchAtLoginUtils.swift
//  DesktopCountdowns
//
//  Created by Dominik Pich on 7/1/20.
//

#if canImport(ServiceManagement)
import ServiceManagement

// MARK: wrapper to manage the caller as a login item
struct LaunchAtLogin {
  static var isEnabled: Bool {
    get {
      return SMAppService.mainApp.status == .enabled
    }
    set {
      do {
        if newValue {
          try SMAppService.mainApp.register()
        } else {
          try SMAppService.mainApp.unregister()
        }
      } catch {
        print("failed to change loginItem status")
        SMAppService.openSystemSettingsLoginItems()
      }
    }
  }
}
#endif
