//
//  QRCodeViewController.swift
//  QRCode Testapp 3.0
//
//  Created by Johann Pfalzgraf on 16.08.18.
//  Copyright © 2018 Johann Pfalzgraf. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
}
