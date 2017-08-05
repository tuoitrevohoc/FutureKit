import Foundation

/// The promise class
/// return a
public class Promise<Result> {
    
    /// The handler type
    public typealias Handler = (Result) -> Void
    
    /// The error handler
    public typealias ErrorHandler = (Error) -> Void
    
    /// The handler
    private var handler: Handler?
    
    /// the error handler
    private var errorHandler: ErrorHandler?
    
    /// the result
    private var result: Result?
    
    /// the error if any
    private var error: Error?
    
    /// lock for waiting the result
    private var lock: NSLock?
    
    /// the result to handle
    public func setResult(_ result: Result) {
        self.result = result
        lock?.unlock()
        handler?(result)
    }
    
    /// Wait for the result and get
    ///
    /// - Returns: the result
    /// - Throws: error if any erro
    public func wait() throws -> Result  {
        var result: Result
        
        if let value = self.result {
            result = value
        } else {
            lock = NSLock()
            lock?.lock()
            lock?.lock()
            
            if let resultValue = self.result {
                result = resultValue
            } else {
                throw error!
            }
        }
        
        return result
    }
    
    /// Raise an error
    ///
    /// - Parameter error: the error
    public func raiseError(error: Error) {
        self.error = error
        lock?.unlock()
        errorHandler?(error)
    }
    
    /// Set the handler
    ///
    /// - Parameter handler: set handler for this promise
    public func then(_ handler: @escaping Handler) {
        self.handler = handler
    }
    
    /// Chain to another promise
    ///
    /// - Parameter handler: the handler
    /// - Returns: the chained promise
    public func then<NextResult>(_ handler: @escaping (Result) -> NextResult)
        -> Promise<NextResult> {
        let chainedPromise = Promise<NextResult>()
            
        then {
            result in
            let nextResult = handler(result)
            chainedPromise.setResult(nextResult)
        }
            
        return chainedPromise
    }
    
    /// Handle error
    ///
    /// - Parameter handler: handle on error
    public func onError(_ handler: @escaping ErrorHandler) {
        self.errorHandler = handler
    }
}

