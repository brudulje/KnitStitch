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
                            .foregroundColor(Color.purple)
                            .font(.headline)
                            .padding(3)
//                            .background(Color.secondary.opacity(0.1))  // no background, using frame instead
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.purple, lineWidth: 1))
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
                Text("Then do like this:")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(viewModel.recipe)
                    .multilineTextAlignment(.leading)
                    .padding(5)
                    .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary, lineWidth: 1))
//                    .textFieldStyle(.roundedBorder)
                    .font(.title2)
                    
                
            }  // end VStack
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button { hideKeyboard() } label: { Text("Done").bold() }
                }
            }
        }  // end GeometryReader
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
