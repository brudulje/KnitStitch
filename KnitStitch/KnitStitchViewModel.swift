//
//  KnitStitchViewModel.swift
//  KnitStitch
//
//  Created by Joachim Seland Graff on 2025-11-22.
//

import Combine

class KnitStitchViewModel: ObservableObject {
    enum EditedField { case before, change, after }

    @Published var before: Int? = nil
    @Published var change: Int? = nil
    @Published var after: Int? = nil
    
    func toggleSign() {
        change = -(change ?? 0)
    }

    func recalcFromBefore() {
        if let b = before, let c = change {
            after = b + c
        }
    }

    func recalcFromChange() {
        if let b = before, let c = change {
            after = b + c
        }
    }

    func recalcFromAfter() {
        if let b = before, let a = after {
            change = a - b
            }
    }
}
