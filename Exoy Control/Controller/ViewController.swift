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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var loadFinished = true
    
    
    
    
    var hostText: String = ""
    let communication = Communication()
    
    var foundDevices: [[Any]] = [[]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpInterface()
        
        load()
    }
    
    func load() {
            DispatchQueue.global(qos: .utility).async {
                DispatchQueue.main.async {
                    self.foundDevices = self.communication.getFoundDevices()
                    print("FLEX: \(self.foundDevices)")
                    var product = ""
                    for i in 1..<self.foundDevices.count{
                        switch self.foundDevices[i][1] as! Int{
                        case 1:
                            product = "hypercube"
                            break
                        case 2:
                            product = "hypercube"
                            break
                        case 3:
                            product = "dodecahedron"
                            break
                        case 4:
                            product = "dodecahedron"
                            break
                        default:
                            product = "mirror"
                        }
                        self.productTitles[i].text = "Exoy \(product.capitalized)"
                        self.namesL[i].text = "\(product.capitalized) #\(self.foundDevices[i][0])"
                        self.productImgs[i].image = UIImage(named: product)
                        self.deviceSV[i].isHidden = false
                    }
                    self.activityIndicator.stopAnimating()
                    self.loadFinished = true
                }
            }
        }
    
    
    @IBAction func connectBtnPressed(_ sender: UIButton) {
        print("AAAAA: \(sender.tag)")
        self.communication.connect(num: Int("\(sender.tag)")!)
        performSegue(withIdentifier: "goToControl", sender: self)
    }
    @IBAction func refreshBtnPressed(_ sender: UIButton) {
        load()
        self.activityIndicator.startAnimating()
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

extension NSObject {
    func copyObject<T:NSObject>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}


