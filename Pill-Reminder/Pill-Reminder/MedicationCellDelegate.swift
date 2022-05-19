//
//  MedicationCellDelegate.swift
//  Pill-Reminder
//
//  Created by mac on 10/3/2022.
//

import Foundation

protocol MedicationCellDelegate: class {
    func didUpdateMedicationCount(for cell: PillsTableViewCell)
}
