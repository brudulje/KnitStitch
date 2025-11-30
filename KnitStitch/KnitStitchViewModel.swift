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
        // Recalculate after when before changes
        if let b = before, let c = change {
            after = b + c
            updateRecipe()
        }
    }

    func recalcFromChange() {
        // Recalculate after when change changes
        if let b = before, let c = change {
            after = b + c
            updateRecipe()
        }
    }

    func recalcFromAfter() {
        // Recalculate change when after changes
        if let b = before, let a = after {
            change = a - b
            updateRecipe()
            }
    }
    
    func updateRecipe() {
        // Update recipe printed in the lower text box when numbers change.
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
                    recipe += "Knit \(howoften) stitches, add one"
                }
                else {
                    recipe += "Knit \(howoften + 1) stitches, add one, \(sometimes) time"
                    if sometimes == 1 { recipe += "" } else { recipe += "s" }
                    recipe += ";\nKnit \(howoften) stitches, add one, \(othertimes) time"
                    if othertimes == 1 { recipe += "" } else { recipe += "s" }
                    
                }
            }
            else  { // Reducing stitches
//                print("Reducing")
                if sometimes == 0 {
                    recipe += "Knit \(abs(howoften) - 2) stitches, two together"
                }
                else {
                    recipe += "Knit \(abs(howoften) - 1) stitches, two together, \(sometimes) time"
                    if sometimes == 1 { recipe += "" } else { recipe += "s" }
                    recipe += ";\nKnit \(abs(howoften) - 2) stitches, two together, \(othertimes) time"
                    if othertimes == 1 { recipe += "" } else { recipe += "s" }
                }
            }
            if sometimes + othertimes != abs(change ?? 0) {
                recipe += ";\nrepeat until end of row."
            }else{
                recipe += "."
            }
        }
    }
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        ///Calculate greatest common divisior of a and b.
        var x = a
        var y = b
        while y != 0 {
            (x, y) = (y, x % y)
        }
        return abs(x)
    }
}
