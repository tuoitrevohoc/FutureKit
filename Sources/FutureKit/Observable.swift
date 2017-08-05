//
//  Observable.swift
//  FutureKitTests
//
//  Created by Tran Thien Khiem on 30/7/17.
//

import Foundation

/// The observable class
/// return a
open class Observable<Event> {

    /// The handler type
    public typealias Handler = (Event) -> Void
    
    /// The handler
    private var handlers: [String: Handler] = [:]
    
    /// initialize an observable
    public init() {
    }
    
    /// the result to handle
    public func publish(_ event: Event) {
        for (_, handler) in handlers {
            handler(event)
        }
    }
    
    /// Set the handler - return the unsubscription function
    ///
    /// - Parameter handler: set handler for this promise
    public func subscribe(_ handler: @escaping Handler) -> (() -> Void) {
        let uuid = UUID().uuidString
        handlers[uuid] = handler
        
        return {
            self.handlers.removeValue(forKey: uuid)
        }
    }
    
    /// return a promise, using for chaining observable
    ///
    /// - Returns: a promise
    public func subscribe() -> Promise<Event> {
        let promise = Promise<Event>()
        let _ = subscribe {
            promise.setResult($0)
        }
        
        return promise
    }
}
