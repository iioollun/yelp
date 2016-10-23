//
//  Filters.swift
//  Yelp
//
//  Created by Un on 10/20/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import Foundation

// Model class that represents the user's search settings
class Filters {
    var searchString = "Restaurant"
    
    var dealValue = false
    
    var distanceValue: Float = 0
    
    var sortByValue = 0 // 0: Best match - 1: Distance - 2: Highest Rated
    
    var categories = [String]()
    
    static let filterModel = Filters()
    
}
