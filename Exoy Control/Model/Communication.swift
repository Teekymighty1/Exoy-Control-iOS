//
//  Communication.swift
//  Exoy Control
//
//  Created by Maksims Rolscikovs on 05/08/2021.
//

import Foundation
import Network

class Communication {
    var IP: NWEndpoint.Host = ""
    
    var hostUDP: NWEndpoint.Host = ""
    let endHostUDP:NWEndpoint.Host = "192.168.8.247"
    var portUDP: NWEndpoint.Port = 8888
    
    var gotAnswer = false
    var ready = true
    
    var connection: NWConnection?
    
    var message: String = ""
    
    var foundDevicesIP: [String] = []
    var foundDevices: [[Any]] = [[]]
    
    func search() {
        var i = 1
        print("search started, i = ", i)
        while i < 254 {
            if (ready) {
                hostUDP = .init("192.168.8.\(i)")
                connectToUDP(hostUDP, portUDP)
                ready = false
                i+=1
            }
        }
        i = 1
        while i < 10 {
            if (ready) {
                hostUDP = .init("192.168.4.\(i)")
                connectToUDP(hostUDP, portUDP)
                ready = false
                i+=1
            }
        }
    }
    
    func getFoundDevices() -> [[Any]]{
        ready = true
        search()
        while !gotAnswer {
            
        }
        if gotAnswer {
            gotAnswer = false
            return foundDevices
        }
        return []
    }
    
    func connect(num: Int) {
        hostUDP = .init(foundDevicesIP[num])
        connectToUDP(hostUDP, portUDP)
    }
    
    func getID() -> Int{
        return parseMessage().ID
    }
    func getType() -> Int{
        return parseMessage().type
    }
    func getCurrentMode() -> Int{
        return parseMessage().currentMode
    }
    func getBrightness() -> Int{
        return parseMessage().brightness
    }
    func getBGBrightness() -> Int{
        return parseMessage().BGBrightness
    }
    func getSpeed() -> Int{
        return parseMessage().speed
    }
    func getHue() -> Int{
        return parseMessage().hue
    }
    func isOn() -> Bool{
        return parseMessage().on
    }
    
    
    func togglePower(){
        if parseMessage().on {
            sendUDP([1,0,0])
        } else {
            sendUDP([1,0,1])
        }
        receiveUDP(IP: hostUDP)
        print(foundDevices)
    }
    func setCurrentMode(mode: UInt8) {
        sendUDP([2,0,mode])
        receiveUDP(IP: hostUDP)
    }
    func setBrightness(br: UInt8) {
        sendUDP([1,1,br])
        receiveUDP(IP: hostUDP)
    }
    func setSpeed(speed: UInt8) {
        sendUDP([2,2,speed])
        receiveUDP(IP: hostUDP)
    }
    func setBGBrightness(bgbr: UInt8){
        sendUDP([2,1,bgbr])
        receiveUDP(IP: hostUDP)
    }
    func calibrate() {
        sendUDP([3,0,0])
        receiveUDP(IP: hostUDP)
    }
    func setColor(hue: UInt8, saturation: UInt8){
        if (hue > 250) {
            sendUDP([2,3,0])
            sendUDP([2,4,0])
        } else {
            sendUDP([2,3,hue])
            sendUDP([2,4,saturation])
        }
    }
    func setEffectChange(effectChange: Bool) {
        sendUDP([1,2,effectChange ? 1 : 0])
        receiveUDP(IP: hostUDP)
    }
    func restart() {
        sendUDP([4,0,0])
    }
    func requestState(){
        sendUDP([0,0,0])
        receiveUDP(IP: hostUDP)
    }
    func getDeviceName(type: Int) -> [String] {
        var product = ""
        var name = ""
        switch(type) {
            case 1:
                product = "hypercube"
                name = "Hypercube"
                break
            case 2:
                product = "udhypercube"
                name = "Ultra Dense Hypercube"
                break
            case 3:
                product = "dodecahedron"
                name = "Dodecahedron"
                break
            case 4:
                product = "uddodecahedron"
                name = "Ultra Dense Dodecahedron"
                break
            case 5:
                product = "mirror"
                name = "Mirror"
                break
            case 6:
                product = "udmirror"
                name = "Ultra Dense Mirror"
                break
            case 7:
                product = "icosahedron"
                name = "Icosahedron"
                 break
            case 8:
                product = "udicosahedron"
                name = "Ultra Dense Icosahedron"
                break
            case 9:
                product = "tetrahedron"
                name = "Tetrahedron"
                break
            case 10:
                product = "udtetrahedron"
                name = "Ultra Dense Tetrahedron"
                break
            case 11:
                product = "hexagon"
                name = "Hexagon"
                break
            case 12:
                product = "udhexagon"
                name = "Ultra Dense Hexagon"
                break
            case 13:
                product = "soundvisualiser"
                name = "Sound Visualiser"
                break
            case 14:
                product = "udsoundvisualiser"
                name = "Ultra Dense Sound Visualiser"
                break
            default:
                product = "infinityobject"
                name = "Infinity Object"
                break
        }
        return [product, name]
    }
    
    
    func parseMessage() -> Message{
        let a = message.components(separatedBy: " ")
        let response: Message = Message.init(ID: Int(a[1])!, type: Int(a[2])!, size: String(a[3]), currentMode: Int(a[4])!, brightness: Int(a[5])!, BGBrightness: Int(a[6])!, speed: Int(a[7])!, hue: Int(a[8])!, saturation: Int(a[9])!, effectChange: a[10] == "1",on: a[11] == "1")
        return response
    }


    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
            // Transmited message:
            
            self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)

            self.connection?.stateUpdateHandler = { (newState) in
                switch (newState) {
                    case .ready:
                        self.sendUDP([0,0,0])
                        self.receiveUDP(IP: hostUDP)
                        break;
                    case .setup:
                        break;
                    case .cancelled:
                        break;
                    case .preparing:
                        break;
                    default:
                        break;
                }
            }

            self.connection?.start(queue: .global())
        }
    func sendUDP(_ content: Data) {
            self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
                if (NWError == nil) {
                    print("Data was sent to UDP")
                } else {
                    print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
                    self.ready = true
                }
            })))
        }

        func sendUDP(_ content: [UInt8]) {
            let contentToSendUDP: [UInt8] = [47,54,content[0],content[1],content[2]]//content.data(using: String.Encoding.utf8)
            self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
                if (NWError == nil) {
                    self.ready = true
                } else {
                    self.ready = true
                }
            })))
        }

    func receiveUDP(IP: NWEndpoint.Host) {
            self.connection?.receiveMessage { (data, context, isComplete, error) in
                print("Receive is complete")
                if (isComplete) {
                    print("Receive is complete")
                    if (data != nil) {
                        let backToString = String(decoding: data!, as: UTF8.self)
                        self.message = backToString
                        print("Received message: \(backToString)")
                        if !self.gotAnswer {
                            if !self.foundDevicesIP.contains("\(IP)") {
                                self.foundDevicesIP.append("\(IP)")
                                let answer: [Any] = [self.parseMessage().ID, self.parseMessage().type, self.parseMessage().size]
                                self.foundDevices.append(answer)
                                self.gotAnswer = true
                            }
                            print("FLEX: \(IP)")
                        }
                        
                    } else {
                        print("Data == nil")
                    }
                }
            }
        }
}
