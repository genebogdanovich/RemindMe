//
//  Image+.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 2.12.20.
//

import Foundation
import SwiftUI

extension Image {
    func modifier<M>(_ modifier: M) -> some View where M: ImageModifier {
        modifier.body(image: self)
    }
}


