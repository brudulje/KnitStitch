//
//  ContentView.swift
//  KnitStitch
//
//  Created by Joachim Seland Graff on 2025-11-19.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = KnitStitchViewModel()
    
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
                numberField(title: "Before", text: Binding(
                    get: { viewModel.before ?? 0 },
                    set: { viewModel.before = $0 }
                ))
                    .onChange(of: viewModel.before) { _ in
                        viewModel.recalcFromBefore()
                    }

                Text("I want to change by:")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Button {
                        viewModel.toggleSign()
                    } label: {
                        Image(systemName: "plus.forwardslash.minus")
                            .font(.title)
                    }
                    numberField(title: "+/-", text: Binding(
                        get: { viewModel.change ?? 0 },
                        set: { viewModel.change = $0 }
                    ), isSigned: true)
                        .onChange(of: viewModel.change) { _ in
                            viewModel.recalcFromChange()
                            }
                }

                Text("To end up with:")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                numberField(title: "After", text: Binding(
                    get: { viewModel.after ?? 0 },
                    set: { viewModel.after = $0 }
                ))
                    .onChange(of: viewModel.after) { _ in
                        viewModel.recalcFromAfter()
                    }
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

//#Preview {
//    ContentView()
//}
