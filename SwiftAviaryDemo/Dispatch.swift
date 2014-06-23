//
//  Dispatch.swift
//  SwiftAviaryDemo
//
//  Created by Michael Vitrano on 6/22/14.
//  Copyright (c) 2014 Vitrano. All rights reserved.
//

import Foundation

enum DispatchQueueIdentifier {
    case Main, PriorityHigh, PriorityDefault, PriorityLow, PriorityBackground
    
    func queue() -> dispatch_queue_t {
        switch(self){
        case .Main:
            return dispatch_get_main_queue()
        case .PriorityHigh:
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        case .PriorityDefault:
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        case .PriorityLow:
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        case .PriorityBackground:
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        }
    }
}

func dispatch_async(queueIdentifer: DispatchQueueIdentifier, block: dispatch_block_t?) {
    dispatch_async(queueIdentifer.queue(), block)
}

func dispatch_sync(queueIdentifer: DispatchQueueIdentifier, block: dispatch_block_t?) {
    dispatch_async(queueIdentifer.queue(), block)
}

func dispatch_main_async(block: dispatch_block_t?) {
    dispatch_async(DispatchQueueIdentifier.Main.queue(), block)
}

func dispatch_main_sync(block: dispatch_block_t?) {
    dispatch_sync(DispatchQueueIdentifier.Main.queue(), block)
}