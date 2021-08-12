//
//  ViewController.swift
//  Exoy Control
//
//  Created by Maksims Rolscikovs on 01/06/2021.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    @IBOutlet weak var conteinerStackView: UIStackView!
    @IBOutlet weak var deviceStackView: UIStackView!
    @IBOutlet weak var hostL: UILabel!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    var hostText: String = ""
    let communication = Communication()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpInterface()
        
        communication.search()
        load()
        
        //deviceSampleView = try! deviceStackView.copyObject() as! UIView
        
    }
    
    func load() {
            DispatchQueue.global(qos: .utility).async {
                DispatchQueue.main.async {
                    let response = self.communication.getHostUDP()
                    self.hostL.text = "Hypercube #\(self.communication.getID())"
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    
    
    @IBAction func connectBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToControl", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controlView = segue.destination as! ControlViewController
        controlView.communication = communication
    }
    
    func setUpInterface() {
        connectBtn.layer.cornerRadius = connectBtn.frame.height / 2
        activityIndicator.startAnimating()
    }
}

extension NSObject {
    func copyObject<T:NSObject>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}


