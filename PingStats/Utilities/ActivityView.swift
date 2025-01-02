//
//  AcitivityView.swift
//  PingStats
//
//  Created by Elvis Dorow on 02/01/25.
//

import SwiftUI
import UIKit

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let completionHandler: ((UIActivity.ActivityType?, Bool, [Any]?, Error?) -> Void)? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        activityViewController.completionWithItemsHandler = completionHandler
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}
