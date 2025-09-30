//
//  IconRenderer.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI
import UIKit

struct IconRenderer {
    
    static func generateAppIcon(size: CGSize = CGSize(width: 1024, height: 1024)) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            
            // Red gradient background
            let colors = [
                UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0).cgColor, // Bright red
                UIColor(red: 0.6, green: 0.15, blue: 0.15, alpha: 1.0).cgColor // Darker red
            ]
            
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: colors as CFArray,
                                    locations: [0.0, 1.0])!
            
            // Draw gradient background with rounded corners
            let cornerRadius = size.width * 0.22 // Standard iOS icon corner radius ratio
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            path.addClip()
            
            context.cgContext.drawLinearGradient(gradient,
                                               start: CGPoint(x: 0, y: 0),
                                               end: CGPoint(x: size.width, y: size.height),
                                               options: [])
            
            // Draw graduation cap icon
            let capSize = size.width * 0.4
            let capRect = CGRect(x: (size.width - capSize) / 2,
                               y: size.height * 0.25,
                               width: capSize,
                               height: capSize)
            
            // Use SF Symbol for graduation cap
            if let graduationCapImage = UIImage(systemName: "graduationcap.fill")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: capSize * 0.8, weight: .medium)) {
                
                graduationCapImage.withTintColor(.white, renderingMode: .alwaysTemplate)
                    .draw(in: capRect, blendMode: .normal, alpha: 1.0)
            }
            
            // Draw text
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size.width * 0.12, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            
            let ccatText = "CCAT"
            let ccatSize = ccatText.size(withAttributes: textAttributes)
            let ccatRect = CGRect(x: (size.width - ccatSize.width) / 2,
                                y: size.height * 0.68,
                                width: ccatSize.width,
                                height: ccatSize.height)
            ccatText.draw(in: ccatRect, withAttributes: textAttributes)
            
            let prepAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size.width * 0.08, weight: .semibold),
                .foregroundColor: UIColor.white.withAlphaComponent(0.9)
            ]
            
            let prepText = "PREP"
            let prepSize = prepText.size(withAttributes: prepAttributes)
            let prepRect = CGRect(x: (size.width - prepSize.width) / 2,
                                y: size.height * 0.78,
                                width: prepSize.width,
                                height: prepSize.height)
            prepText.draw(in: prepRect, withAttributes: prepAttributes)
        }
    }
    
    static func saveIconToDocuments() {
        guard let icon = generateAppIcon() else {
            print("Failed to generate icon")
            return
        }
        
        guard let data = icon.pngData() else {
            print("Failed to convert icon to PNG data")
            return
        }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask)[0]
        let iconURL = documentsPath.appendingPathComponent("app_icon_1024.png")
        
        do {
            try data.write(to: iconURL)
            print("Icon saved to: \(iconURL.path)")
        } catch {
            print("Failed to save icon: \(error)")
        }
    }
}

// Extension to easily render SwiftUI views as images
extension View {
    func renderAsImage(size: CGSize) -> UIImage? {
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = UIColor.clear
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
