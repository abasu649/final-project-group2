//
//  ViewController.swift
//  439FinalProject
//
//  Created by Andrew Wu on 2/16/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func testMapBox(_ sender: Any) {
        performSegue(withIdentifier: "trailMap", sender: self)
    }
    
    @IBAction func testMapBox2(_ sender: Any) {
        let vc2 = TrailMapViewController()
        vc2.modalPresentationStyle = .fullScreen
        self.present(vc2, animated: true, completion: nil)
    }
}

