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
                ZStack {
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
                   
                }
                .frame(height: geo.size.height * 0.04)
                Text("I have this many stitches:")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                numberField(title: "Before", text: $before)
                Text("I want to change by:")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                    
                    numberField(title: (changeSign == .add ? "+/-" : "-/+"), text: $change)
                    
                }
                Text("To end up with:")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
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
