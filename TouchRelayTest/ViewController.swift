//
//  ViewController.swift
//  TouchRelayTest
//
//  Created by Blake Tsuzaki on 11/21/17.
//  Copyright © 2017 modoki. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    let socket = WebSocket(url: URL(string: "ws://evan.local:8000/x")!, protocols: ["chat"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGestureRecognizer.addTarget(self, action: #selector(ViewController.userDidPan))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        socket.delegate = self
        socket.connect()
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    @objc func userDidPan(sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view)
//        headerLabel.text = "x: \(touchPoint.x), y: \(touchPoint.y)"
        
        socket.write(string: "\(max(min(Int(touchPoint.x),255),0))")
    }
}

extension ViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        headerLabel.text = "Connected"
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        headerLabel.text = "Disconnected"
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {}
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}
}
