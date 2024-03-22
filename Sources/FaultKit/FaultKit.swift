// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct DataErrorFault: Codable, Equatable {
    public let code: Int, type: String, message: String
}

public class ErrorFault: Error, Codable, Equatable {
    public var data: DataErrorFault?
    
    public static func == (lhs: ErrorFault, rhs: ErrorFault) -> Bool {
        return lhs.data == rhs.data
    }
    
    public static func create(
        code: Int = 499, 
        type: String = "Unknown Error",
        message: String = "There is an unknown error occurring."
    ) -> ErrorFault {
        let dataFault = DataErrorFault(
            code: code,
            type: type,
            message: message)
        let errorFault = ErrorFault()
        errorFault.data = dataFault
        return errorFault
    }
}

public extension Error {
    func asHTTPError(code: Int) -> ErrorFault {
        let dataFault = DataErrorFault(
            code: code,
            type: "HttpError", 
            message: self.localizedDescription
        )
        let errorFault = ErrorFault()
        errorFault.data = dataFault
        return errorFault
    }
}

public extension Result {
    var mapAsHTTPError: Result<Success, ErrorFault> {
        self.mapError {
            $0.asHTTPError(code: 499)
        }
    }
}
