//
//  DebuggerUtils.swift
//  DesktopCountdowns
//
//  Created by Dominik Pich on 7/2/20.
//

#if DEBUG
import Foundation

// MARK: Tools for development
struct DeveloperUtils {
  static func isDebuggerAttached() -> Bool {
    var info = kinfo_proc()
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
    var size = MemoryLayout<kinfo_proc>.stride
    let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
    guard junk == 0 else {
      print("sysctl failed, assume no debugger")
      return false
    }
    return (info.kp_proc.p_flag & P_TRACED) != 0
  }
  
  static func isInPreviewMode() -> Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
  }
}
#endif
