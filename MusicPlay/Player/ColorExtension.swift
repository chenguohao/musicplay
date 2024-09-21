//
//  ColorExtension.swift
//  MusicPlay
//
//  Created by Chen guohao on 9/21/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let scanner = Scanner(string: hexString)
        var rgb: UInt64 = 0
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        let a = hexString.count == 8 ? Double((rgb & 0xFF000000) >> 24) / 255.0 : 1.0
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
