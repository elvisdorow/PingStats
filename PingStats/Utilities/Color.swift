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
    var appRedColor: Color { get }
    var chartColor: Color { get }
}

struct DefaultColorTheme: ColorTheme {
    var accent: Color = Color("AccentColor")
    var darkAccent: Color = Color("DarkAccent")
    var iconColor: Color = Color("IconColor")
    var backgroundTop: Color = Color("BackgroundTop")
    var backgroundBottom: Color = Color("BackgroundBottom")
    var gaugeDarkColor: Color = Color("GaugeDarkColor")
    var gaugeLightColor: Color = Color("GaugeLightColor")
    var appRedColor: Color = Color("AppRedColor")
    var chartColor: Color = Color("ChartColor")
}
