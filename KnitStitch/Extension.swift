//
//  Extension.swift
//  KnitStitch
//
//  Created by Joachim Seland Graff on 2025-11-22.
//

import SwiftUI

extension ContentView {
    // MARK: - Reusable number field
    @ViewBuilder
    func numberField(title: String, text: Binding<String>) -> some View {
        HStack {
            Spacer()
            // TextField with numpad
            TextField(title, text: text)
                .keyboardType(.numberPad)            // ← opens numeric keypad
                .frame(width: 120  )
                .font(.largeTitle)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(.roundedBorder)
                .onChange(of: text.wrappedValue) { new in
                    // Detect if this is the Change field (title begins with "+" or "-")
                    if title.hasPrefix("+") || title.hasPrefix("-") {
                        // Extract digits only
                        let digits = new.filter { $0.isNumber }
                        let limited = String(digits.prefix(4))
                        
                        // Preserve correct sign based on title
                        let sign = title.hasPrefix("+") ? "+" : "-"
                        
                        // Update text to include sign + digits
                        if limited.isEmpty {
                            text.wrappedValue = sign
                        } else {
                            text.wrappedValue = sign + limited
                        }
                    } else {
                        // Normal number field (Before, After)
                        let filtered = new.filter { $0.isNumber }
                        let limited = String(filtered.prefix(4))
                        text.wrappedValue = limited
                    }
                }
            // Plus / minus buttons
            HStack(spacing: 12) {
                Button(action: { adjust(text: text, amount: -1) }) {
                    Image(systemName: "minus.square")
                        .font(.title)
                }
                
                Button(action: { adjust(text: text, amount: +1) }) {
                    Image(systemName: "plus.square")
                        .font(.title)
                }
            }
        }
    }
    
    // MARK: - Helper for increment/decrement
    func adjust(text: Binding<String>, amount: Int) {
        let isSigned = text.wrappedValue.hasPrefix("+") || text.wrappedValue.hasPrefix("-")
        
        if isSigned {
            let signChar = text.wrappedValue.first == "-" ? "-" : "+"
            let digits = text.wrappedValue.dropFirst().filter { $0.isNumber }
            let current = Int(digits) ?? 0
            let updated = max(0, min(9999, current + amount))
            text.wrappedValue = signChar + String(updated)
        } else {
            let current = Int(text.wrappedValue) ?? 0
            let updated = max(0, min(9999, current + amount))
            text.wrappedValue = String(updated)
        }
    }
}
