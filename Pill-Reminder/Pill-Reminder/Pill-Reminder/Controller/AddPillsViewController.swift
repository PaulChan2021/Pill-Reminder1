//
//  AddPillsViewController.swift
//  Pill-Reminder
//
//  Created by mac on 10/3/2022.
//

import UIKit

class AddPillsViewController: UIViewController {
    
    //Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dosageTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var numberOfTimesLabel: UILabel!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var medicationController: MedicationController?
    var medication: Medication?
    var advanceTimeBy: Int = 0
    var dateArray = [Date]()
    let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        dosageTextField.delegate = self
        quantityTextField.delegate = self
        updateViews()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Configuration
    private func updateViews() {
        if let medication = medication {
            titleLabel.text = "Edit Medication"
            nameTextField.text = medication.name
            dosageTextField.text = "\(medication.dosage)"
            quantityTextField.text = "\(medication.quantity)"
            datePicker.setDate(medication.times[0], animated: false)
            
            switch medication.units {
            case .mg:
                unitSegmentedControl.selectedSegmentIndex = 0
            case .U:
                unitSegmentedControl.selectedSegmentIndex = 1
            }
            
            datePicker.date = medication.times[0]
            stepper.value = Double(medication.times.count)
            numberOfTimesLabel.text = "\(Int(stepper.value))"
        } else {
            titleLabel.text = "Add Medication"
        }
    }
    
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        sender.minimumValue = 1
        sender.maximumValue = 4
        sender.stepValue = 1
        numberOfTimesLabel.text = "\(Int(sender.value))"
        advanceTimeBy = 24 / Int(sender.value)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let medicationController = medicationController else { return }
        guard let name = nameTextField.text, let dosageString = dosageTextField.text, let quantityString = quantityTextField.text,
            !name.isEmpty, !dosageString.isEmpty, !quantityString.isEmpty, let dosage = Int(dosageString), let quantity = Int(quantityString) else { return }
        var units: MedicationUnit = .mg
        
        let components = Calendar.current.dateComponents([.hour], from: datePicker.date)
        let hour = components.hour ?? 0
        dateArray.append(datePicker.date)
        
        for number in 1 ..< Int(stepper.value) {
            var changeHour = hour
            changeHour = hour + (number * advanceTimeBy)
            var newComponents = DateComponents()
            newComponents.hour = changeHour
            newComponents.minute = components.minute
            let newDate = Calendar.current.date(from: newComponents) ?? Date()
            dateArray.append(newDate)
        }
        
        switch unitSegmentedControl.selectedSegmentIndex {
        case 0:
            units = .mg
        case 1:
            units = .U
        default:
            break
        }
        
        if let medication = medication {
            medicationController.update(medication, with: UInt32(quantity), dosage: dosage, times: dateArray)
        } else {
            medicationController.createMedication(with: name, quantity: UInt32(quantity), dosage: dosage, units: units, times: dateArray)
        }
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddPillsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
