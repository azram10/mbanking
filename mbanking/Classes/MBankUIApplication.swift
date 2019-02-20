//
//  MBankUIApplication.swift
//  mbanking
//
//  Created by Azra Mesic on 19/02/2019.
//  Copyright © 2019 Azra Mesic. All rights reserved.
//

import Foundation
import UIKit

extension NSNotification.Name {
    public static let TimeOutUserInteraction: NSNotification.Name = NSNotification.Name(rawValue: "TimeOutUserInteraction")
}


class MBankUIApplication: UIApplication {
    
    static let ApplicationDidTimeoutNotification = "AppTimeout"
    
    let timeoutInSeconds: TimeInterval = 60 * 5
    
    var idleTimer: Timer?
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        if event.allTouches?.first(where: { $0.phase == .began }) != nil {
            resetIdleTimer()
        }
    }
    
    func resetIdleTimer() {
        idleTimer?.invalidate()
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds, target: self, selector: #selector(self.idleTimerExceeded), userInfo: nil, repeats: false)
    }
    
    @objc func idleTimerExceeded() {
        Foundation.NotificationCenter.default.post(name: NSNotification.Name(rawValue: MBankUIApplication.ApplicationDidTimeoutNotification), object: nil)
    }
}

