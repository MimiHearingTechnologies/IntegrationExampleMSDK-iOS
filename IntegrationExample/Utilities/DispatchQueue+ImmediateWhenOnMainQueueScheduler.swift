//
//  DispatchQueue+ImmediateWhenOnMainQueueScheduler.swift
//  MimiSDK iOS
//
//  Created by Salar on 1/31/24.
//  Copyright © 2024 Mimi Hearing Technologies GmbH. All rights reserved.
//

import Foundation
import Combine

/// An extension on `DispatchQueue` providing a custom scheduler for immediate execution on the main queue if already on the main thread.
extension DispatchQueue {
    
    /// Returns an immediate scheduler when on the main queue.
    static var immediateWhenOnMainQueueScheduler: ImmediateWhenOnMainQueueScheduler {
        return ImmediateWhenOnMainQueueScheduler()
    }
    
    /// A scheduler that performs actions immediately when on the main queue and delegates to the main queue otherwise.
    class ImmediateWhenOnMainQueueScheduler: Scheduler {
        
        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        /// This scheduler’s definition of the current moment in time.
        var now: SchedulerTimeType {
            return DispatchQueue.main.now
        }

        /// The minimum tolerance allowed by the scheduler.
        var minimumTolerance: SchedulerTimeType.Stride {
            return DispatchQueue.main.minimumTolerance
        }

        /// Performs the action at the next possible opportunity.
        func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
            guard Thread.isMainThread else {
                DispatchQueue.main.schedule(options: options, action)
                return
            }
            action()
        }

        /// Performs the action at some time after the specified date.
        func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }

        /// Performs the action at some time after the specified date, at the specified frequency, optionally taking into account tolerance if possible.
        func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }
}
