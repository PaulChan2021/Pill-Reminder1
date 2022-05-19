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
    
    /// Computed property to return all medications needing a refill.
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
    /// Function to create a new medication
    /// - Parameters:
    ///   - name: The name of the medication
    ///   - dosage: The strength of the medication
    ///   - units: The units for the medication
    ///   - schedule: When the medication should be taken
    func createMedication(with name: String, quantity: UInt32, dosage: Int, units: MedicationUnit, times: [Date]) {
        let newMedication = Medication(name: name, dosage: dosage, units: units, quantity: quantity, times: times)
        medications.append(newMedication)
        saveToPersistentStore()
    }
    
    /// Function to update the medication count
    /// - Parameters:
    ///   - medication: The medication which will be changed
    ///   - count: The new count for the medication
    func update(_ medication: Medication, with count: UInt32, dosage: Int, times: [Date]) {
        guard let index = medications.firstIndex(of: medication) else { return }
        medications[index].quantity = UInt32(count)
        medications[index].dosage = dosage
        medications[index].times = times
        saveToPersistentStore()
    }
    
    /// Function to delete the passed in medication from the Array
    /// - Parameter medication: The medication to be deleted
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
    
    /// Function to save medication objects to the persistent file storage
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
    
    /// Function to load medication objects from persistent storage
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

