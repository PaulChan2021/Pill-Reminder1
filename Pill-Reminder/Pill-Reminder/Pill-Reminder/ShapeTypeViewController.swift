//
//  ShapeTypeViewController.swift
//  Pill-Reminder
//
//  Created by mac on 25/5/2022.
//

import UIKit
import AVKit
import Vision

class ShapeTypeViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var belowViews: UIView!
    @IBOutlet weak var accuracyLabels: UILabel!
    @IBOutlet weak var shapeTypeLabel: UILabel!
    
    let model = Resnet50().model
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //camera
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        // The camera is now created!
        
        view.addSubview(belowViews)
        
        belowViews.clipsToBounds = true
        belowViews.layer.cornerRadius = 15.0
        belowViews.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        
        let  dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            
            let name: String = firstObservation.identifier
            let acc: Int = Int(firstObservation.confidence * 100)
            
            DispatchQueue.main.async {
                self.shapeTypeLabel.text = name
                self.accuracyLabels.text = "Accuracy: \(acc)%"
            }
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }

    

}
