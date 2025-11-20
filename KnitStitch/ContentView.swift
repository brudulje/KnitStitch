//
//  ContentView.swift
//  KnitStitch
//
//  Created by Joachim Seland Graff on 2025-11-19.
//

import SwiftUI

struct ContentView: View {
    
    @State private var before: String = ""
    @State private var change: String = ""
    @State private var after: String = ""
    
    enum ChangeSign {
        case add
        case subtract
    }
    
    @State private var changeSign: ChangeSign = .add
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack (alignment: .topTrailing) {
                    HStack{
                        // Logo
                        Spacer()
                        Text("KnitStitch")
                            .font(.headline)
                            .padding(3)
                            .background(Color.black.opacity(0.5))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Spacer()
                    }
//                    Menu("☰"){
//                        
//                    }
//                    .padding(.horizontal)
//                    .foregroundColor(Color.black)
//                    .font(.title)
                    
                }
                .frame(height: geo.size.height * 0.04)
                Text("I have this many stitches:")
                    .multilineTextAlignment(.leading)
                numberField(title: "Before", text: $before)
                Text("I want to change by:")
                    .multilineTextAlignment(.leading)
                HStack {
                    Button {
                        changeSign = (changeSign == .add ? .subtract : .add)
                        let digits = change.dropFirst().filter { $0.isNumber }
                        let newSign = (changeSign == .add ? "+" : "-")
                        if digits.isEmpty {
                            change = newSign
                        } else {
                            change = newSign + digits
                        }
                    } label: {
                        Image(systemName: "plus.forwardslash.minus")
                            .font(.title)
                    }
                    
                    numberField(title: (changeSign == .add ? "+ Change" : "- Change"), text: $change)
                    
                }
                Text("To end up with:")
                    .multilineTextAlignment(.leading)
                
                numberField(title: "After", text: $after)
            }
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        hideKeyboard()
                    }
                }
            }
        }
    } // end View
    
    // MARK: - Reusable number field
    @ViewBuilder
    func numberField(title: String, text: Binding<String>) -> some View {
        HStack {
            // TextField with numpad
            TextField(title, text: text)
                .keyboardType(.numberPad)            // ← opens numeric keypad
            //                   .frame()
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

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
#Preview {
    ContentView()
}
