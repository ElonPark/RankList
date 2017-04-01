//
//  ViewController.swift
//  Ranklist
//
//  Created by Nebula_MAC on 2016. 1. 8..
//  Copyright © 2016년 Nebula_MAC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

        @IBOutlet var infoData: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        infoData?.text = "Data From\n SK플래닛 Open API\n영화진흥위원회 Open API "
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToMenu(_ sender : UIStoryboardSegue){
        
    }
    
}

