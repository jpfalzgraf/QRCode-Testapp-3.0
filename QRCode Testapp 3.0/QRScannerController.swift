//
//  QRScannerController.swift
//  QRCode Testapp 3.0
//
//  Created by Johann Pfalzgraf on 16.08.18.
//  Copyright © 2018 Johann Pfalzgraf. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController {
    
    // Outlets
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet weak var btnNavToModel: UIBarButtonItem!
    @IBOutlet var statusLabel: UILabel!
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var appDelegate: AppDelegate!
    
    // Unterstützte QR/Strich - Code Typen
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        btnNavToModel.isEnabled = false
        
        // Get the back-facing camera for capturing videos .builtInWideAngleCamera
        // let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)(Funktioniert nur bei iPhone + Modellen, wegen dem Cameratyp)
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            statusLabel.text = "Failed to get the camera device"
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            // captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        
        
        // Move the message label and status label to the front
        
        // view.bringSubview(toFront: topbar)
        
        // Initialize QR Code Frame to highlight the QR code
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        messageLabel.text = "Kein QR Code erkannt"
        view.bringSubview(toFront: messageLabel)
        view.bringSubview(toFront: statusLabel)
        
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.orange.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        
        view.sendSubview(toBack: messageLabel)
        view.sendSubview(toBack: statusLabel)
        qrCodeFrameView?.removeFromSuperview()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // messege label - Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "Kein QR Code erkannt"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                // launchApp(decodedURL: metadataObj.stringValue!)
                // messageLabel.text = metadataObj.stringValue
                
                // Global variable to use in another App-Views
                
                appDelegate.modelName = metadataObj.stringValue
                
                switch metadataObj.stringValue {
                case "ar_model_01": messageLabel.text = "Model 1 gefunden"
                statusLabel.text = "Modell 1 geladen"
                btnNavToModel.isEnabled = true
                captureSession.stopRunning()
                case "ar_model_02": messageLabel.text = "Model 2 gefunden"
                statusLabel.text = "Modell 2 geladen"
                btnNavToModel.isEnabled = true
                captureSession.stopRunning()
                case "ar_model_03": messageLabel.text = "Model 3 gefunden"
                statusLabel.text = "Modell 3 geladen"
                btnNavToModel.isEnabled = true
                captureSession.stopRunning()
                case "ar_model_04": messageLabel.text = "Model 4 gefunden"
                statusLabel.text = "Modell 4 geladen"
                btnNavToModel.isEnabled = true
                captureSession.stopRunning()
                case "ar_model_05": messageLabel.text = "Model 5 gefunden"
                statusLabel.text = "Modell 5 geladen"
                btnNavToModel.isEnabled = true
                captureSession.stopRunning()
                default: messageLabel.text = "Kein Model gefunden"
                statusLabel.text = "Kein gültiges Modell geladen"
                btnNavToModel.isEnabled = false
                }
            }
        }
    }
}
