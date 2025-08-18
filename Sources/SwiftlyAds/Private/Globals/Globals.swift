//
//  File.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 07/08/25.
//

import Foundation

func doWork(after time: TimeInterval, execute: @Sendable @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: execute)
}
