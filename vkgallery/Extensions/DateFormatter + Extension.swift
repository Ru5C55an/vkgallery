//
//  DateFormatter + Extension.swift
//  vkgallery
//
//  Created by Руслан Садыков on 11.08.2021.
//

import Foundation

extension DateFormatter {
    static let ddMMMMyyyy: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = .current
        return dateFormatter
    }()
}
