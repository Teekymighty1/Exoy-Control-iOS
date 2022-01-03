//
//  Device.swift
//  Exoy Control
//
//  Created by Maksims Rolscikovs on 03/08/2021.
//

import Foundation

struct Device {
    let IP: String
    let ID: Int
    let type: Int // 1,2 - cube, 3,4 - dodecahedron, 5,6 - mirror
    let size: String
}

struct Message {
//    let IP: String
    let ID: Int
    let type: Int // 1,2 - cube, 3,4 - dodecahedron, 5,6 - mirror
    let size: String
    let currentMode: Int
    let brightness: Int
    let BGBrightness: Int
    let speed: Int
    let hue: Int
    let saturation: Int
    let effectChange: Bool
    let on: Bool
}




