//
//  ViewController.swift
//  KnxApp
//
//  Created by Trond Kjeldås on 01/05/2017.
//  Copyright © 2017 Trond Kjeldås. All rights reserved.
//

import UIKit
import KnxBasics2

class ViewController: UIViewController, KnxOnOffResponseHandlerDelegate {

    var lightOnOffSwitch : KnxOnOffControl? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Set the address to the server running EIBD
        KnxRouterInterface.routerIp = "gax58"
        KnxRouterInterface.multicastGroup = "224.0.23.12"
        KnxRouterInterface.connectionType = .udpMulticast


        // Add the DPT for your address to the address registry
        KnxGroupAddressRegistry.addTypeForGroupAddress(address: KnxGroupAddress(fromString:"1/0/16"),
                                                       type: KnxTelegramType.dpt1_xxx)

        // Instantiate a light switch for the address
        lightOnOffSwitch = KnxOnOffControl(setOnOffAddress: KnxGroupAddress(fromString: "1/0/16"),
                                           responseHandler:self)
    }

    // UI action method for the switch
    @IBAction func switchChanged(_ sender: UISwitch?) {

        if let sw = sender,
            let lightOnOffSwitch = lightOnOffSwitch {

            // Turn bulb on according to switch state
            if(sw.isOn) {
                lightOnOffSwitch.lightOn = true
            } else {
                lightOnOffSwitch.lightOn = false
            }
        }
    }

    // Response method, gets called when the group address is written,
    // typically used to sync up UI with system state
    func onOffResponse(sender: KnxGroupAddress, state:Bool) {
        print("State of lightbulb: \(state)")
    }
}
