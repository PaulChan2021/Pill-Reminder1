//
//  PillsTableViewController.swift
//  Pill-Reminder
//
//  Created by mac on 10/3/2022.
//

import UIKit

class PillsTableViewController: UITableViewController {

    let medicationController = MedicationController()
    let defaults = UserDefaults.standard
    let center = UNUserNotificationCenter.current()
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medicationController.medications.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.medicationInfoCell, for: indexPath) as? PillsTableViewCell else { return UITableViewCell() }
        
        let medication = medicationController.medications[indexPath.row]
        cell.delegate = self
        cell.medication = medication
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let medication = medicationController.medications[indexPath.row]
            medicationController.deleteMedication(medication)
            center.removePendingNotificationRequests(withIdentifiers: [medication.lowDoseId])
            center.removePendingNotificationRequests(withIdentifiers: medication.timesId)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.addMeds:
            guard let addMedsVC = segue.destination as? AddPillsViewController else { return }
            addMedsVC.medicationController = medicationController
        case Segues.editMeds:
            guard let addMedsVC = segue.destination as? AddPillsViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            addMedsVC.medication = medicationController.medications[indexPath.row]
            addMedsVC.medicationController = medicationController
        default:
            break
        }
    }
}

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - MedicationCellDelegate Extension
extension PillsTableViewController: MedicationCellDelegate {
    func didUpdateMedicationCount(for cell: PillsTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let medication = medicationController.medications[indexPath.row]
        medicationController.update(medication, with: medication.quantity - 1, dosage: medication.dosage, times: medication.times)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


