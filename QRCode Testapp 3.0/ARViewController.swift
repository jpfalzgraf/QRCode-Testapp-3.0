//
//  ViewController.swift
//  QRCode Testapp 3.0
//
//  Created by Johann Pfalzgraf on 16.08.18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    // outlets
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var modelNode: SCNNode?
    var object_exist: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //--------------------------
//        let scanningPanel = UIImageView()
//        scanningPanel.backgroundColor = UIColor(white: 0.33, alpha: 0.6)
//        scanningPanel.layer.masksToBounds = true
//        scanningPanel.frame = CGRect(x: 80, y: self.sceneView.frame.height-240, width: 240, height: 40)
//        scanningPanel.layer.cornerRadius = 15
//        
//        let scanInfo = UILabel(frame: CGRect(x: 82, y: self.sceneView.frame.height-238, width: 250, height: 45))
//        scanInfo.textAlignment = .left
//        scanInfo.font = scanInfo.font.withSize(15)
//        scanInfo.textColor = UIColor.white
//        scanInfo.text = "Tippe auf den bildschirm"
//        
//        self.sceneView.addSubview(scanningPanel)
//        self.sceneView.addSubview(scanInfo)
        //--------------------------
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/gear copy.scn")!
        self.modelNode = scene.rootNode.childNode(withName: "MDL_OBJ", recursively: true)
        self.modelNode?.position = SCNVector3Make(0, 0, -1)
        
        //        let material = SCNMaterial()
        //        material.diffuse.contents = UIImage(named: "Raw meat.jpg")
        //
        // Set the scene to the view
        //        sceneView.scene = scene
        
        self.object_exist = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let treeClone = modelNode!.clone()
        if self.object_exist == false {
            guard let touch = touches.first else { return }
            let results = sceneView.hitTest(touch.location(in: sceneView), types:
                [ARHitTestResult.ResultType.featurePoint])
            guard let hitFeature = results.last else { return }
            let hitTransform = SCNMatrix4(hitFeature.worldTransform)
            let hitPosition = SCNVector3Make(hitTransform.m41,
                                             hitTransform.m42,
                                             hitTransform.m43)
            
            treeClone.position = hitPosition
            sceneView.scene.rootNode.addChildNode(treeClone)
            self.object_exist = true
            statusLabel.text = "Zum Entfernen tippen"
        } else {
            print(sceneView.scene.rootNode.childNodes.count)
            print(sceneView.scene.rootNode.childNodes)
            sceneView.scene.rootNode.childNodes.last?.removeFromParentNode()
            self.object_exist = false
            statusLabel.text = "Zum Platzieren tippen"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported {
            let configuration = ARWorldTrackingConfiguration()
            sceneView.session.run(configuration)        }
        else  {
            let configuration = AROrientationTrackingConfiguration()
            sceneView.session.run(configuration)        }
        
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        //sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
