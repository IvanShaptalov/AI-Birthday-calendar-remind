//
//  EventColorController.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 23.03.2024.
//

import Foundation
import UIKit

enum Season{
    case
    Winter,
    SpringSeason,
    Summer,
    Autumn
}

class EventSeasonController {
    /// generates season color
    static func getSeason(_ date: Date) -> Season{
        let dateComponent = Calendar.current.dateComponents([.month], from: date)
        
        guard let month = dateComponent.month else {
            return .Winter
        }
        
        switch month {
            case 3,4,5:
                return .SpringSeason
            case 12,1,2:
                return .Winter
            case 6,7,8:
                return .Summer
            case 9,10,11:
                return.Autumn
            default:
                return.Winter
        }
        
        
    }
}
