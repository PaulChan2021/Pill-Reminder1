//
//  Medication.swift
//  Pill-Reminder
//
//  Created by mac on 10/3/2022.
//

import Foundation

struct Medication: Equatable, Codable {
    let name: String
    var dosage: Int
    let units: MedicationUnit
    var quantity: UInt32
    var times: [Date]
    
    
    //Returns for low dosage notifications
    var lowDoseId: String {
        return "\(name)\(dosage)\(quantity)"
    }
    
    
    //Returns for daily dosage notifications
    var timesId: [String] {
        var stringArray = [String]()
        for time in times {
            let components = Calendar.current.dateComponents([.hour], from: time)
            let hour = components.hour ?? 0
            stringArray.append("\(name)\(dosage)\(hour)")
        }
        return stringArray
    }
}

//describing the units for the medicaiton
enum MedicationUnit: String, Codable {
    case mg = "miligrams"
    case U = "units"
}
