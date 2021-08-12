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
    var portUDP: NWEndpoint.Port = 8888
    
    var gotAnswer = false
    var ready = true
    
    var connection: NWConnection?
    
    var message: String = ""
    
    func search() {
        var i = 1
        while !gotAnswer && i < 249 {
            if (ready) {
                hostUDP = .init("192.168.8.\(i)")
                connectToUDP(hostUDP, portUDP)
                ready = false
                i+=1
            }
        }
        
        if (gotAnswer) {
            connection?.cancel()
            return
        }
        
    }
    
    func getHostUDP() -> String{
        while !gotAnswer {
            
        }
        if gotAnswer {
            
            return "\(hostUDP)"
        }
        return ""
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
    
    
    func togglePower(){
        requestState()
        print(parseMessage().on)
        if parseMessage().on {
            sendUDP("P_OFF")
        } else {
            sendUDP("P_ON")
        }
        receiveUDP(IP: hostUDP)
    }
    func setCurrentMode(mode: Int) {
        sendUDP("EFF\(mode)")
        receiveUDP(IP: hostUDP)
    }
    func setBrightness(br: Int) {
        sendUDP("BRI\(br)")
    }
    func setAcutance(ac: Int) {
        sendUDP("SPD\(ac)")
    }
    func setBGBrightness(bgbr: Int){
        sendUDP("BGB\(bgbr)")
    }
    func calibrate() {
        sendUDP("CAL")
    }
    func setColor(hue: Int, saturation: Int){
        if (hue > 250) {
            sendUDP("CLR0 0")
        } else {
            sendUDP("CLR\(hue)\(String(hue).count == 1 ? "   " : String(hue).count == 2 ? "  " : " ")\(saturation)")
        }
    }
    func setEffectChange(effectChange: Bool) {
        sendUDP("EFCH\(effectChange ? 1 : 0)")
    }
    func requestState(){
        sendUDP("GET")
        receiveUDP(IP: hostUDP)
    }
    
    func parseMessage() -> Message{
        let a = message.components(separatedBy: " ")
        let response: Message = Message.init(ID: Int(a[1])!, type: Int(a[2])!, size: String(a[3]), currentMode: Int(a[4])!, brightness: Int(a[5])!, BGBrightness: Int(a[6])!, speed: Int(a[7])!, hue: Int(a[8])!, saturation: Int(a[9])!, effectChange: a[10] == "1",on: a[11] == "1")
        return response
    }


    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
            // Transmited message:
            print("Connecting...", hostUDP)
            let messageToUDP = "GET"

            self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)

            self.connection?.stateUpdateHandler = { (newState) in
                print("This is stateUpdateHandler:")
                switch (newState) {
                    case .ready:
                        print("State: Ready\n")
                        self.sendUDP(messageToUDP)
                        self.receiveUDP(IP: hostUDP)
                    case .setup:
                        print("State: Setup\n")
                    case .cancelled:
                        print("State: Cancelled\n")
                    case .preparing:
                        print("State: Preparing\n")
                    default:
                        print("ERROR! State not defined!\n")
                        self.ready = true
                }
            }

            self.connection?.start(queue: .global())
        }
    func sendUDP(_ content: Data) {
        print(hostUDP)
            self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
                if (NWError == nil) {
                    print("Data was sent to UDP")
                } else {
                    print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
                    self.ready = true
                }
            })))
        }

        func sendUDP(_ content: String) {
            print(hostUDP)
            let contentToSendUDP = content.data(using: String.Encoding.utf8)
            self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
                if (NWError == nil) {
                    print("Data was sent to UDP")
                    self.ready = true
                } else {
                    print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
                    self.ready = true
                }
            })))
        }

    func receiveUDP(IP: NWEndpoint.Host) {
            self.connection?.receiveMessage { (data, context, isComplete, error) in
                if (isComplete) {
                    print("Receive is complete")
                    if (data != nil) {
                        let backToString = String(decoding: data!, as: UTF8.self)
                        self.message = backToString
                        print("Received message: \(backToString)")
                        if !self.gotAnswer {
                            self.gotAnswer = true
                            self.hostUDP = .init("\(IP)")
                            self.connectToUDP(self.hostUDP, self.portUDP)
                        }
                    } else {
                        print("Data == nil")
                    }
                }
            }
        }
}
