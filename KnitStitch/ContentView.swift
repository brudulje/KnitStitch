//
//  ContentView.swift
//  KnitStitch
//
//  Created by Joachim Seland Graff on 2025-11-19.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = KnitStitchViewModel()
    @State private var showAbout: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .topTrailing) {
                    HStack {
                        Spacer()
                        Text("KnitStitch")
                            .foregroundColor(Color.purple)
                            .font(.headline)
                            .padding(5)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.purple, lineWidth: 2))
                        Spacer()
                        
                    }
                    Menu {
                        Button("ℹ About") { showAbout = true }
                    }label: {
                        Text("☰")
                            .frame(width: geo.size.width * 0.1,
                                   height: geo.size.width * 0.1)
                            .font(.title)
//                            .foregroundColor(Color.purple)
//                            .background(Color.purple.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .padding(.trailing, 6)
                    }
                }
                .frame(height: geo.size.height * 0.04)

                Text("Starting with this many stitches:")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                numberField(title: "Before", text: Binding(
                    get: { viewModel.before ?? 0 },
                    set: { viewModel.before = $0 }
                ))
                    .onChange(of: viewModel.before) { _ in
                        viewModel.recalcFromBefore()
                    }

                Text("I want to increase / decrease by:")
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
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
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
