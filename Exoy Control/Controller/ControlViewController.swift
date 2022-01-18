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
    @IBOutlet weak var powerBtn: UIButton!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var effectChangeSwitch: UISwitch!
    @IBOutlet weak var productName: UILabel!
    
    var communication = Communication()
    var productOn = false
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        productOn = communication.isOn()
        
        setUpInterface()
        setSettings()
        setSettingsDelay()
    }
    
    func setSettingsDelay() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(setSettings), userInfo: nil, repeats: false)
    }
    
    @IBAction func ONOFFpressed(_ sender: UIButton) {
        communication.togglePower()
        productOn = !productOn
        powerBtn.setImage(UIImage(named: (productOn ? "poweron" : "poweroff")), for: .normal)
        setSettingsDelay()
    }
    @IBAction func brSliderChange(_ sender: UISlider) {
        communication.setBrightness(br: UInt8(sender.value+100))
        setSettingsDelay()
    }
    @IBAction func acSliderChange(_ sender: UISlider) {
        communication.setSpeed(speed: UInt8(sender.value))
        setSettingsDelay()
    }
    @IBAction func bgBrSliderChange(_ sender: UISlider) {
        communication.setBGBrightness(bgbr: UInt8(sender.value))
        setSettingsDelay()
    }
    @IBAction func calibratePressed(_ sender: UIButton) {
        communication.calibrate()
        setSettingsDelay()
    }
    @IBAction func effectBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToEffects", sender: self)
    }
    @IBAction func restartBtnPressed(_ sender: Any) {
        communication.restart()
    }
    

    @IBAction func colorSliderChanged(_ sender: UISlider) {
        sender.tintColor = UIColor(hue: CGFloat(sender.value/255), saturation: 1, brightness: 1, alpha: 1)
        if sender.value > 250 {
            sender.tintColor = UIColor.gray
        }
        communication.setColor(hue: UInt8(sender.value), saturation: 255)
        setSettingsDelay()
    }
    @IBAction func effectChangeSwitchPressed(_ sender: UISwitch) {
        communication.setEffectChange(effectChange: sender.isOn)
        setSettingsDelay()
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
        acutanceSlider.isContinuous = false
        brightnessSlider.isContinuous = false
        bgBrigthnessSlider.isContinuous = false
        colorSlider.isContinuous = false
        
        startCalibrationBtn.layer.cornerRadius = startCalibrationBtn.frame.height / 2
        backBtn.layer.cornerRadius = backBtn.frame.height / 2
        
    }
    
    @objc func setSettings(){
        powerBtn.setImage(UIImage(named: (communication.isOn() ? "poweron" : "poweroff")), for: .normal)
        acutanceSlider.setValue(Float(communication.getSpeed()), animated: true)
        brightnessSlider.setValue(Float(communication.getBrightness())-100, animated: true)
        bgBrigthnessSlider.setValue(Float(communication.getBGBrightness()), animated: true)
        colorSlider.setValue(Float(communication.getHue()), animated: true)
        colorSlider.tintColor = UIColor(hue: CGFloat(communication.getHue()/255), saturation: 1, brightness: 1, alpha: 1)
        if communication.getHue() == 0 {
            colorSlider.tintColor = UIColor.gray
            colorSlider.setValue(255, animated: true)
        }
        productName.text = "Exoy " + communication.getDeviceName(type: communication.getType())[1]
        effectChangeSwitch.isOn = communication.getEffectChange()
    }
    
    

}
