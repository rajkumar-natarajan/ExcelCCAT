//
//  AppIconGenerator.swift
//  ExcelCCAT
//
//  Created by Rajkumar Natarajan on 2025-09-30.
//

import SwiftUI

struct AppIconView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Red background
            RoundedRectangle(cornerRadius: size * 0.22) // Standard iOS icon corner radius ratio
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.8, green: 0.2, blue: 0.2), // Bright red
                            Color(red: 0.6, green: 0.15, blue: 0.15) // Darker red
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
            
            // Graduation cap
            VStack(spacing: size * 0.02) {
                // Cap top
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: size * 0.35, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: size * 0.01, x: 0, y: size * 0.01)
                
                // Text
                VStack(spacing: size * 0.01) {
                    Text("CCAT")
                        .font(.system(size: size * 0.12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: size * 0.005, x: 0, y: size * 0.005)
                    
                    Text("PREP")
                        .font(.system(size: size * 0.08, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.3), radius: size * 0.005, x: 0, y: size * 0.005)
                }
            }
            .offset(y: -size * 0.02) // Slightly move up for better centering
        }
    }
}

// Helper view to generate icon at different sizes
struct AppIconGeneratorView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("App Icon Preview")
                .font(.title)
                .padding()
            
            HStack(spacing: 20) {
                VStack {
                    AppIconView(size: 60)
                    Text("60pt")
                        .font(.caption)
                }
                
                VStack {
                    AppIconView(size: 80)
                    Text("80pt")
                        .font(.caption)
                }
                
                VStack {
                    AppIconView(size: 120)
                    Text("120pt")
                        .font(.caption)
                }
            }
            
            VStack {
                AppIconView(size: 200)
                Text("200pt (Preview)")
                    .font(.caption)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    AppIconGeneratorView()
}
