//
//  USState.swift
//  Facephoto
//
//  Created by Steven on 5/19/16.
//  Copyright © 2016 PluckPhoto. All rights reserved.
//

import UIKit

/// Represents a state in the United States.
enum USState: String {
    
    // MARK: - Init
    
    init?(abbreviation: String) {
        let keys = (abbreviationList as NSDictionary).allKeys(for: abbreviation.uppercased())
        let stateName = (keys as! [String]).first
        
        if stateName != nil {
            self.init(stateName: stateName!)
        } else {
            return nil
        }
    }
    
    init?(stateName: String) {
        self.init(rawValue: stateName)
    }
    
    // MARK: - Utility
    
    var fullName: String {
        get {
            return rawValue
        }
    }
    
    var abbreviation: String {
        get {
            return abbreviationList[fullName]!
        }
    }
    
    // MARK: - States
    
    case Alabama = "Alabama"
    case Alaska = "Alaska"
    case Arizona = "Arizona"
    case Arkansas = "Arkansas"
    case California = "California"
    case Colorado = "Colorado"
    case Connecticut = "Connecticut"
    case Delaware = "Delaware"
    case Florida = "Florida"
    case Georgia = "Georgia"
    case Hawaii = "Hawaii"
    case Idaho = "Idaho"
    case Illinois = "Illinois"
    case Indiana = "Indiana"
    case Iowa = "Iowa"
    case Kansas = "Kansas"
    case Kentucky = "Kentucky"
    case Louisiana = "Louisiana"
    case Maine = "Maine"
    case Maryland = "Maryland"
    case Massachusetts = "Massachusetts"
    case Michigan = "Michigan"
    case Minnesota = "Minnesota"
    case Mississippi = "Mississippi"
    case Missouri = "Missouri"
    case Montana = "Montana"
    case Nebraska = "Nebraska"
    case Nevada = "Nevada"
    case NewHampshire = "New Hampshire"
    case NewJersey = "New Jersey"
    case NewMexico = "New Mexico"
    case NewYork = "New York"
    case NorthCarolina = "North Carolina"
    case NorthDakota = "North Dakota"
    case Ohio = "Ohio"
    case Oklahoma = "Oklahoma"
    case Oregon = "Oregon"
    case Pennsylvania = "Pennsylvania"
    case RhodeIsland = "Rhode Island"
    case SouthCarolina = "South Carolina"
    case SouthDakota = "South Dakota"
    case Tennessee = "Tennessee"
    case Texas = "Texas"
    case Utah = "Utah"
    case Vermont = "Vermont"
    case Virginia = "Virginia"
    case Washington = "Washington"
    case WestVirginia = "West Virginia"
    case Wisconsin = "Wisconsin"
    case Wyoming = "Wyoming"
}

/// A list of mappings from full state name to abbreviation name.
private let abbreviationList: [String: String] = [
    "Alabama": "AL",
    "Alaska": "AK",
    "Arizona": "AZ",
    "Arkansas": "AR",
    "California": "CA",
    "Colorado": "CO",
    "Connecticut": "CT",
    "Delaware": "DE",
    "Florida": "FL",
    "Georgia": "GA",
    "Hawaii": "HI",
    "Idaho": "ID",
    "Illinois": "IL",
    "Indiana": "IN",
    "Iowa": "IA",
    "Kansas": "KS",
    "Kentucky": "KY",
    "Louisiana": "LA",
    "Maine": "ME",
    "Maryland": "MD",
    "Massachusetts": "MA",
    "Michigan": "MI",
    "Minnesota": "MN",
    "Mississippi": "MS",
    "Missouri": "MO",
    "Montana": "MT",
    "Nebraska": "NE",
    "Nevada": "NV",
    "New Hampshire": "NH",
    "New Jersey": "NJ",
    "New Mexico": "NM",
    "New York": "NY",
    "North Carolina": "NC",
    "North Dakota": "ND",
    "Ohio": "OH",
    "Oklahoma": "OK",
    "Oregon": "OR",
    "Pennsylvania": "PA",
    "Rhode Island": "RI",
    "South Carolina": "SC",
    "South Dakota": "SD",
    "Tennessee": "TN",
    "Texas": "TX",
    "Utah": "UT",
    "Vermont": "VT",
    "Virginia": "VA",
    "Washington": "WA",
    "West Virginia": "WV",
    "Wisconsin": "WI",
    "Wyoming": "WY"
]
