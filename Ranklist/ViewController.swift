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
        
        self.infoData?.text = "Data From\n SK플래닛 Open API\n영화진흥위원회 Open API "
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToMenu(sender : UIStoryboardSegue){
        
    }
    
}

/*
    3D터치, peek & pop 구현, 홈 숏컷 구현
홈 숏컷에서 매우 헤매였다. 
1.앱이 백그라운드에 실행중에 숏컷을 실행하면 뷰가 지워지지 않고 뷰가 그려지기 때문에 오류가 발생한다.
2.그것을 해결하기 위해 숏컷으로 화면으로 넘겨주기전에 dismissViewControllerAnimated을 실행하고 presentViewController 메소드를 실행한다.
숏컷을 앱 실행전에 실행하면 뷰가 없어서 오류가 난다.
그런데             
// This will block "performActionForShortcutItem:completionHandler" from being called.
shouldPerformAdditionalDelegateHandling = true //false를 true로 바꾸었더니 뷰가 겹치지 않고 잘됨 ???

아마 실행중에 숏컷 실행시 핸들링 하는것으로 추정

기간
16.01.08-16.01.13

*/