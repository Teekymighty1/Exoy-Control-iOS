//
//  EffectViewController.swift
//  Exoy Control
//
//  Created by Maksims Rolscikovs on 05/08/2021.
//

import UIKit

class EffectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var communication: Communication = Communication()
    var controlView: ControlViewController? = nil
    @IBOutlet weak var effectPicker: UIPickerView!
    var effectList: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.effectPicker.delegate = self
        self.effectPicker.dataSource = self
        
        effectList = ["Color", "Color Shift", "Rainbow", "Stroboscope", "Colorful Stroboscope", "Fire", "Volume", "Breathing", "Lines", "Rainbow reaction", "Color reaction", "Life", "Stars Reaction", "Stars", "Volume up"]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return effectList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return effectList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        communication.setCurrentMode(mode: row)
        dismiss(animated: true, completion: nil)
        controlView?.setSettings()
    }
    
    
    
}
