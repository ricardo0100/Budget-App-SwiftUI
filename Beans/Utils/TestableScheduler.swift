//
//  TestableScheduler.swift
//  Beans
//
//  Created by Ricardo Gehrke on 02/12/20.
//

import Foundation
import Combine

public class TestableScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler
where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
    
    private let _minimumTolerance: () -> SchedulerTimeType.Stride
    private let _now: () -> SchedulerTimeType
    private let _scheduleAfterIntervalToleranceOptionsAction: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> Cancellable
    private let _scheduleAfterToleranceOptionsAction: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> Void
    private let _scheduleOptionsAction: (SchedulerOptions?, @escaping () -> Void) -> Void
    
    private let isTesting: Bool
    private var scheduledActions: [(SchedulerTimeType, () -> Void)] = []
    
    public var minimumTolerance: SchedulerTimeType.Stride { self._minimumTolerance() }
    public var now: SchedulerTimeType { self._now() }
    
    public init<S>(_ scheduler: S, isTesting: Bool = false) where S: Scheduler, S.SchedulerTimeType == SchedulerTimeType, S.SchedulerOptions == SchedulerOptions {
        self._now = { scheduler.now }
        self._minimumTolerance = { scheduler.minimumTolerance }
        self._scheduleAfterToleranceOptionsAction = scheduler.schedule
        self._scheduleAfterIntervalToleranceOptionsAction = scheduler.schedule
        self._scheduleOptionsAction = scheduler.schedule
        self.isTesting = isTesting
    }
    
    public func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
        self._scheduleAfterToleranceOptionsAction(date, tolerance, options, action)
    }
    
    public func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
        self._scheduleOptionsAction(options, action)
    }
    
    public func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
        guard isTesting else {
            return self._scheduleAfterIntervalToleranceOptionsAction(date, interval, tolerance, options, action)
        }
        scheduledActions.append((date, action))
        scheduledActions.sort { $0.0 < $1.0 }
        return AnyCancellable { }
    }
    
    public func advance(in time: SchedulerTimeType.Stride) {
        guard isTesting else {
            fatalError("This should only be used in unit testing environment!")
        }
        
        executeAllActions(until: now.advanced(by: time))
    }
    
    private func executeAllActions(until: SchedulerTimeType) {
        scheduledActions.forEach { (time, action) in
            guard time <= until else {
                return
            }
            action()
        }
    }
}

public typealias TestableSchedulerOf<Scheduler> = TestableScheduler<Scheduler.SchedulerTimeType, Scheduler.SchedulerOptions> where Scheduler: Combine.Scheduler

extension Scheduler {
    public func eraseToAnyScheduler() -> TestableScheduler<SchedulerTimeType, SchedulerOptions> {
        TestableScheduler(self)
    }
}
