import SwiftUI
extension ContentView {
    // MARK: - Reusable number field
    @ViewBuilder
    func numberField(title: String, text: Binding<Int>, isSigned: Bool = false) -> some View {
        HStack {
            Spacer()
            // TextField with numpad
            TextField(title, text: Binding(
                get: {
                    // Tapping a field containing 0 will remove the 0 from the field.
                    if text.wrappedValue == 0 {
                        return ""
                    }
                    return isSigned ? String(format: "%+d", text.wrappedValue)
                                    : String(text.wrappedValue)
                },
                set: { newValue in
                    // Remove all non-numeric and non-sign characters
                    let filtered = newValue.filter { $0.isNumber || $0 == "+" || $0 == "-" }
                    if let intValue = Int(filtered) {
                        text.wrappedValue = intValue
                    }
                }
            ))
            .keyboardType(.numberPad)
            .frame(width: 120)
            .font(.largeTitle)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(.roundedBorder)
            .onTapGesture {
                if text.wrappedValue == 0 {
                    text.wrappedValue = 0  // leave the integer value
                }
            }
            
            // Plus / minus buttons
            HStack(spacing: 12) {
                Button(action: { text.wrappedValue -= 1 }) {
                    Image(systemName: "minus.square")
                        .font(.title)
                }
                
                Button(action: { text.wrappedValue += 1 }) {
                    Image(systemName: "plus.square")
                        .font(.title)
                }
            }
        }
    }
    
    // MARK: - Helper for increment/decrement
    func adjust(text: Binding<Int>, amount: Int) {
        let current = text.wrappedValue
        let updated = max(0, min(9999, current + amount))
        text.wrappedValue = updated
    }
}
