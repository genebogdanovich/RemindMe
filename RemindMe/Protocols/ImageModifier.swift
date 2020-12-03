//
//  ImageModifier.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 3.12.20.
//

import Foundation
import SwiftUI

/// This protocol allows you to add View Modifiers to Image objects.
protocol ImageModifier {
    associatedtype Body: View
    
    func body(image: Image) -> Self.Body
}
