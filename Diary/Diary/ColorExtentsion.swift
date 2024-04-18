//
//  ColorExtentsion.swift
//  Diary
//
//  Created by Simmons on 4/18/24.
//

import SwiftUI

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}

extension Color {
 
    static let hex5E3D25 = Color(hex: "5E3D25")
    static let hex886D5A = Color(hex: "886D5A")
    static let hexD8CDC3 = Color(hex: "D8CDC3")
    static let hexFFDCAB = Color(hex: "FFDCAB")
    
    static let hexEFEFEF = Color(hex: "EFEFEF")
    
    static let hex677775 = Color(hex: "677775")
    static let hexBDCFCD = Color(hex: "BDCFCD")
}
