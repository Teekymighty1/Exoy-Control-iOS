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
    @IBOutlet var deviceSV: [UIStackView]!
    @IBOutlet var namesL: [UILabel]!
    @IBOutlet var connectBtns: [UIButton]!
    @IBOutlet var productImgs: [UIImageView]!
    @IBOutlet var productTitles: [UILabel]!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var loadFinished = true
    
    
    
    
    var hostText: String = ""
    let communication = Communication()
    
    var foundDevices: [[Any]] = [[]]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpInterface()
        let _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(search), userInfo: nil, repeats: false)
        
     }
    
    @objc func search() {
        let _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkDevices), userInfo: nil, repeats: false)
        do {
            try self.communication.startSearch()
            warningLabel.text = ""
        }
        catch _ as Network{
            warningLabel.text = "Please connect to Wi-Fi"
        }
        catch {
            
        }
    }
    
    @objc func checkDevices() {
        self.foundDevices = self.communication.getFoundDevices()
        var product = ""
        var name = ""
        
        if (self.foundDevices.count == 1) {
            search()
        }
        else {
                for i in 1..<self.foundDevices.count{
                let names = self.communication.getDeviceName(type: self.foundDevices[i][1] as! Int)
                product = names[0]
                name = names[1]
                self.productTitles[i].text = "Exoy \(name)"
                self.namesL[i].text = "\(name) #\(self.foundDevices[i][0])"
                self.productImgs[i].image = UIImage(named: product)
                self.deviceSV[i].isHidden = false
            }
            self.activityIndicator.stopAnimating()
            self.loadFinished = true
        }
    }
    
    
    @IBAction func connectBtnPressed(_ sender: UIButton) {
        self.communication.connect(num: Int("\(sender.tag)")!)
        self.communication.confirmConnection()
        performSegue(withIdentifier: "goToControl", sender: self)
    }
    @IBAction func refreshBtnPressed(_ sender: UIButton) {
        self.activityIndicator.startAnimating()
        self.loadFinished = false
        let _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkDevices), userInfo: nil, repeats: false)
        do {
            try self.communication.startSearch()
        }
        catch {
            
        }
    }
    @IBAction func fbBtnPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.facebook.com/exoylighting")!, options: [:], completionHandler: nil)
    }
    @IBAction func instBtnPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.instagram.com/exoylighting/")!, options: [:], completionHandler: nil)
    }
    @IBAction func helpBtnPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://exoy.eu/pages/contact-us")!, options: [:], completionHandler: nil)
    }
    @IBAction func cartBtnPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.exoy.eu")!, options: [:], completionHandler: nil)
    }
    

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controlView = segue.destination as! ControlViewController
        controlView.communication = communication
    }
    
    func setUpInterface() {
        for _connectBtn in connectBtns {
            _connectBtn.layer.cornerRadius = _connectBtn.frame.height / 2
        }
        for _deviceSV in deviceSV {
            _deviceSV.isHidden = true
        }
        
        activityIndicator.startAnimating()
    }
}



