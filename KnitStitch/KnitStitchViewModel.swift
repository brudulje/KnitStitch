//
//  KnitStitchViewModel.swift
//  KnitStitch
//
//  Created by Joachim Seland Graff on 2025-11-22.
//

import Combine

class KnitStitchViewModel: ObservableObject {

    @Published var before: Int? = nil
    @Published var change: Int? = nil
    @Published var after: Int? = nil
    @Published var recipe: String = ""
    
    func toggleSign() {
        change = -(change ?? 0)
    }

    func recalcFromBefore() {
        if let b = before, let c = change {
            after = b + c
            updateRecipe()
        }
    }

    func recalcFromChange() {
        if let b = before, let c = change {
            after = b + c
            updateRecipe()
        }
    }

    func recalcFromAfter() {
        if let b = before, let a = after {
            change = a - b
            updateRecipe()
            }
    }
    
    func updateRecipe() {
        recipe = ""
        if let b = before, let c = change {
            if c == 0 {return}  // avoid trying to divide by zero
            
            let howoften = b / c
            var sometimes = b % c
            var othertimes = abs(c) - sometimes
            
            let g = gcd(sometimes, othertimes)  // Reduce to smallest numbers
            sometimes /= g
            othertimes /= g
            
            
            if c > 0 {  // Adding stitches
//                print("Adding")
                if sometimes == 0 {
//                    print("Rest is zero")
                    recipe += "Knit \(howoften) stitches, add one;\n"
                }
                else {
//                    print("Rest is non-zero")
                    recipe += "Knit \(howoften + 1) stitches, add one, \(sometimes) times;\n"
                    recipe += "Knit \(howoften) stitches, add one, \(othertimes) times;\n"
                }
            }
            else  { // Reducing stitches
//                print("Reducing")
                if sometimes == 0 {
//                    print("Rest is zero")
                    
                    recipe += "Knit \(abs(howoften) - 2) stitches, two together;\n"
                }
                else {
//                    print("Rest is non-zero")
                    recipe += "Knit \(abs(howoften) - 1) stitches, two together, \(sometimes) times;\n"
//                    print("Knit ", howoften - 1, "stitches, two together, ", rest, "times, ")
                    recipe += "Knit \(abs(howoften) - 2) stitches, two together, \(othertimes) times;\n"
//                    print("Knit ", howoften - 2, "stitches, two together, ", c - rest, "times, ")
                }
            }
            
            recipe += "repeat until end."
        }
    }
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var x = a
        var y = b
        while y != 0 {
            (x, y) = (y, x % y)
        }
        return abs(x)
    }
}
