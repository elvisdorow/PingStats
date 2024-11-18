//
//  Color.swift
//  PingStats
//
//  Created by Elvis Dorow on 07/11/24.
//

import Foundation
import SwiftUI

extension Color {
    static let theme: ColorTheme = DefaultColorTheme()
}

protocol ColorTheme {
    var accent: Color { get }
    var darkAccent: Color { get }
    var iconColor: Color { get }
    var backgroundTop: Color { get }
    var backgroundBottom: Color { get }
    var gaugeDarkColor: Color { get }
    var gaugeLightColor: Color { get }
}

struct DefaultColorTheme: ColorTheme {
    var accent: Color = Color("accent")
    var darkAccent: Color = Color("darkAccent")
    var iconColor: Color = Color("iconColor")
    var backgroundTop: Color = Color("backgroundTop")
    var backgroundBottom: Color = Color("backgroundBottom")
    var gaugeDarkColor: Color = Color("gaugeDarkColor")
    var gaugeLightColor: Color = Color("gaugeLightColor")
}
