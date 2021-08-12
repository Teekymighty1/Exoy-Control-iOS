//
//  ControlViewController.swift
//  Exoy Control
//
//  Created by Maksims Rolscikovs on 05/08/2021.
//

import UIKit

class ControlViewController: UIViewController {
    
    @IBOutlet weak var colorSlider: UISlider!
    @IBOutlet weak var acutanceSlider: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var bgBrigthnessSlider: UISlider!
    @IBOutlet weak var startCalibrationBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var communication = Communication()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpInterface()
        setSettings()
    }
    
    @IBAction func ONOFFpressed(_ sender: UIButton) {
        communication.togglePower()
    }
    @IBAction func brSliderChange(_ sender: UISlider) {
        communication.setBrightness(br: Int(sender.value))
    }
    @IBAction func acSliderChange(_ sender: UISlider) {
        communication.setAcutance(ac: Int(sender.value))
    }
    @IBAction func bgBrSliderChange(_ sender: UISlider) {
        communication.setBGBrightness(bgbr: Int(sender.value))
    }
    @IBAction func calibratePressed(_ sender: UIButton) {
        communication.calibrate()
    }
    @IBAction func effectBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToEffects", sender: self)
    }

    @IBAction func colorSliderChanged(_ sender: UISlider) {
        sender.tintColor = UIColor(hue: CGFloat(sender.value/255), saturation: 1, brightness: 1, alpha: 1)
        if sender.value > 250 {
            sender.tintColor = UIColor.gray
        }
        communication.setColor(hue: Int(sender.value), saturation: 255)
    }
    @IBAction func effectChangeSwitchPressed(_ sender: UISwitch) {
        communication.setEffectChange(effectChange: sender.isOn)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let effectView = segue.destination as! EffectViewController
        effectView.communication = communication
        effectView.controlView = self
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpInterface(){
        startCalibrationBtn.layer.cornerRadius = startCalibrationBtn.frame.height / 2
        backBtn.layer.cornerRadius = backBtn.frame.height / 2
        
        
    }
    
    func setSettings(){

        acutanceSlider.setValue(Float(communication.getSpeed()), animated: true)
        brightnessSlider.setValue(Float(communication.getBrightness()), animated: true)
        bgBrigthnessSlider.setValue(Float(communication.getBGBrightness()), animated: true)
        colorSlider.setValue(Float(communication.getHue()), animated: true)
        colorSlider.tintColor = UIColor(hue: CGFloat(communication.getHue()/255), saturation: 1, brightness: 1, alpha: 1)
        if communication.getHue() > 250 {
            colorSlider.tintColor = UIColor.gray
        }
    }
    
    

}
