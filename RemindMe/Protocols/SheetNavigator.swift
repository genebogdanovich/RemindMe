//
//  SheetNavigator.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 3.12.20.
//

import SwiftUI

protocol SheetNavigator: ObservableObject {
    associatedtype SheetDestination
    func sheetView() -> AnyView
}
