//
//  ColorViewController.swift
//  Exoy Control
//
//  Created by Maksims Rolscikovs on 05/08/2021.
//

import UIKit

class ColorViewController: UIViewController {
    
    var communication: Communication? = nil
    @IBOutlet weak var colorWheel: ColorWheel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func handleTap (_ gestureRecognizer : UITapGestureRecognizer ){
        let point = gestureRecognizer.location(in: colorWheel)
        print(colorWheel.colorAtPoint(point: point))
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
