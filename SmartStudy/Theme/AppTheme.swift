//
//  AppTheme.swift
//  SmartStudy
//
//  Created by Woohyuk Song on 2026-03-26.
//

import Foundation
import SwiftUI

struct AppTheme {
    // Main colors
    static let accent     = Color(red: 0.79, green: 0.66, blue: 0.43)
    static let background = Color(red: 0.97, green: 0.96, blue: 0.94)
    static let cardBG     = Color.white
    static let textDark   = Color(red: 0.17, green: 0.17, blue: 0.17)
    static let textGray   = Color(red: 0.60, green: 0.56, blue: 0.51)

    // Deck tag colors
    static let tagGreen  = Color(red: 0.72, green: 0.84, blue: 0.78)
    static let tagBeige  = Color(red: 0.91, green: 0.84, blue: 0.72)
    static let tagPurple = Color(red: 0.78, green: 0.75, blue: 0.85)
    static let tagRed    = Color(red: 0.95, green: 0.77, blue: 0.77)

    static let allTagColors = [tagGreen, tagBeige, tagPurple, tagRed]
    static let tagColors = [tagGreen, tagBeige, tagPurple, tagRed]
    
    static let cornerMedium: CGFloat = 12

}
