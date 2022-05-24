//
//  MedicationCellDelegate.swift
//  Pill-Reminder
//
//  Created by mac on 24/5/2022.
//

import Foundation

import Foundation

protocol MedicationCellDelegate: AnyObject {
    func didUpdateMedicationCount(for cell: PillsTableViewCell)
}
