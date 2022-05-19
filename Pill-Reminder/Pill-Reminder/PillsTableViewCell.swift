//
//  PillsTableViewCell.swift
//  Pill-Reminder
//
//  Created by mac on 10/3/2022.
//

import UIKit

class PillsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dosageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    weak var delegate: MedicationCellDelegate?
    
    var medication: Medication? {
        didSet {
            updateViews()
        }
    }
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func updateViews() {
        var timeString = ""
        guard let medication = medication else { return }
        nameLabel.text = medication.name
        dosageLabel.text = "\(medication.dosage)\(medication.units)"
        for time in medication.times {
            timeString += dateFormatter.string(from: time).replacingOccurrences(of: ":00", with: "") + "\t"
        }
        timeLabel.text = timeString
        quantityLabel.text = "Qty: \(medication.quantity)"
    }
    @IBAction func takenButtonTapped(_ sender: UIButton) {
        delegate?.didUpdateMedicationCount(for: self)
    }
}
