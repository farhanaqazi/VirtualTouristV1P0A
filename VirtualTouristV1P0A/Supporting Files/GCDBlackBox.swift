//
//  GCDBlackBox.swift
//  VirtualTouristV1P0A
//
//  Created by Farhan Qazi on 3/31/19.
//  Copyright © 2019 Farhan Qazi. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
