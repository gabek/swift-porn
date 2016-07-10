//
//  ViewController.swift
//  SwiftPornExample
//
//  Created by Gabe Kangas on 7/9/16.
//  Copyright © 2016 Gabe Kangas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = DateTimeRequest()
        let service = Services()
        service.test(request) { (response) in
            print(response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

