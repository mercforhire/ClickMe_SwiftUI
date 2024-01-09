//
//  NavigationStack+Ext.swift
//  ClickMe
//
//  Created by Leon Chen on 2024-01-05.
//

import Foundation
import SwiftUI

extension NavigationStack {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `NavigationView`.
    /// - Returns: Either the original `NavigationView` or the modified `NavigationView` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
