//
//  MedicationController.swift
//  Pill-Reminder
//
//  Created by mac on 10/3/2022.
//

import Foundation

class MedicationController {
    
    var medications = [Medication]()
    
    /// Computed property to return all medications that dont need refills.
    var medicationsFilled: [Medication] {
        return medications.filter( { $0.quantity > 0} )
    }
    
    var medicationsNeedFilled: [Medication] {
        return medications.filter( { $0.quantity == 0 } )
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Initialization
    init() {
        loadFromPersistentStore()
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - CRUD methods

    func createMedication(with name: String, quantity: UInt32, dosage: Int, units: MedicationUnit, times: [Date]) {
        let newMedication = Medication(name: name, dosage: dosage, units: units, quantity: quantity, times: times)
        medications.append(newMedication)
        saveToPersistentStore()
    }
    

    func update(_ medication: Medication, with count: UInt32, dosage: Int, times: [Date]) {
        guard let index = medications.firstIndex(of: medication) else { return }
        medications[index].quantity = UInt32(count)
        medications[index].dosage = dosage
        medications[index].times = times
        saveToPersistentStore()
    }
    
    // Function to delete medication

    func deleteMedication(_ medication: Medication) {
        guard let index = medications.firstIndex(of: medication) else { return }
        medications.remove(at: index)
        saveToPersistentStore()
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Persistence
    private var persistentFileURL: URL? = {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentsDirectory.appendingPathComponent("Medications.plist")
    }()
    
    // save medication objects
    private func saveToPersistentStore() {
        let encoder = PropertyListEncoder()
        guard let fileURL = persistentFileURL else { return }
        do {
            let medicationData = try encoder.encode(medications)
            try medicationData.write(to: fileURL)
        } catch let saveError {
            print("Error saving medications to file: \(saveError.localizedDescription)")
        }
    }
    
    private func loadFromPersistentStore() {
        let decoder = PropertyListDecoder()
        let fileManager = FileManager.default
        guard let fileURL = persistentFileURL, fileManager.fileExists(atPath: fileURL.path) else { return }
        do {
            let medicationData = try Data(contentsOf: fileURL)
            medications = try decoder.decode([Medication].self, from: medicationData)
        } catch let loadError {
            print("Error loading medications from file: \(loadError.localizedDescription)")
        }
    }
}

