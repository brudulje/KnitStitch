//
//  AboutView.swift
//  KnitStitch
//
//  Created by Joachim Seland Graff on 2025-11-24.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 20) {
                        Text("""
                        KnitStitch helps you increase or decrease evenly throughout the row when knitting.
                        """)

                        Text("""
                        Sometimes you have to increase or decrease a number of stitches that doesen't divide nicely into the number of stitches you have. KnitStitch does the math for you and helps making the increase or decrease evenly spread over the row.
                        """)
                        
                        Text("""
                        Specify how many stitches you have and how many you want to add or remove. Alternatively, specify how many you have and how many you want to end up with.
                        """)
                            .multilineTextAlignment(.leading)
                        
                        Text("""
                        Version \(version) \nCreated by Joachim Seland Graff
                        """)
                        .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                .navigationTitle("About KnitStitch")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    AboutView()
}
