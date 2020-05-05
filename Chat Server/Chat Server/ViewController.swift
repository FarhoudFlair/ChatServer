//
//  ViewController.swift
//  Chat Server
//
//  Created by Farhoud on 2020-04-04.
//  Copyright © 2020 Farhoud Talebi. All rights reserved.
//

import UIKit
import Starscream


class ViewController: UIViewController {
    var socket = WebSocket(request: URLRequest(url: URL(string: "ws://localhost:3000/")!))
    @IBOutlet var addressInput: UITextField!
    @IBOutlet var messageInput: UITextField!
    @IBOutlet var chatBox: UITextView!
    @IBAction func connectServer(_ connect: UIButton){
        progressBar.setProgress(1, animated: true)
        var address: String;
        address = addressInput.text!;
        socket = WebSocket(request: URLRequest(url: URL(string: "ws://"+address)!))
        socket.delegate = self
        socket.connect()
        chatBox.text = ""
    }
    @IBAction func sendMessage(_ send: UIButton){
        guard let msg = messageInput.text else { return }
        sendMessage(msg)
    }
    @IBAction func disconnectServer(_ disconnect: UIButton){
        progressBar.setProgress(0, animated: true)
        socket.disconnect()
        socket.delegate = nil
    }
    @IBOutlet var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    deinit {
        socket.disconnect()
        socket.delegate = nil
    }
    
}


fileprivate extension ViewController {
    func sendMessage(_ message: String) {
      socket.write(string: message)
    }
    
    func messageReceived(_ message: String) {
        chatBox.text = (chatBox.text ?? "") + message + "\n"
    }
}


// MARK: - WebSocketDelegate
extension ViewController : WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .text(let txt):
            print(txt)
            messageReceived(txt)
        case .connected(_):
            print("connected")
        case .disconnected(_, _):
            print("disconnected")
        case .binary(_):
            print("binary")
        case .pong(_):
            print("pong")
        case .ping(_):
            print("ping")
        case .error(_):
            print("error")
        case .viablityChanged(_):
            print("viability changed")
        case .reconnectSuggested(_):
            print("reconnect suggested")
        case .cancelled:
            print("cancelled")
        }
        
    }
}

