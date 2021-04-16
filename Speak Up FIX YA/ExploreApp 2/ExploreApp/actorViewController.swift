//
//  actorViewController.swift
//  team 6 (Maps)
//
//  Created by Septia Rosalina Malik on 07/04/21.
//

import UIKit

class actorViewController: UIViewController {


    @IBOutlet weak var btn_bill: UIButton!
    @IBOutlet weak var btn_waitress: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_waitress.layer.cornerRadius = 15.0
        btn_bill.layer.cornerRadius = 15.0
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
