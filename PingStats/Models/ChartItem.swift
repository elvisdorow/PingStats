//
//  PingChartItem.swift
//  PingStats
//
//  Created by Elvis Dorow on 15/11/24.
//

import Foundation

struct ChartItem: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let sequence: Int
    var duration: Double
}

