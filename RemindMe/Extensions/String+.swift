//
//  String+.swift
//  RemindMe
//
//  Created by Gene Bogdanovich on 27.11.20.
//

import Foundation

extension String {
    func makeUrl() -> URL? {
        guard !self.isEmpty else { return nil }
        
        if self.hasPrefix("https://") || self.hasPrefix("http://") {
            let url = URL(string: self)
            return url
        } else {
            let correctedUrl = "http://\(self)"
            let url = URL(string: correctedUrl)
            return url
        }
    }
}
