// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// `DataErrorFault` is a struct that encapsulates error information in a codable and comparable form.
public struct DataErrorFault: Codable, Equatable {
    /// The error code.
    public let code: Int
    /// The type of error as a string.
    public let type: String
    /// A human-readable message describing the error.
    public let message: String
}

/// `ErrorFault` is a class representing an error that conforms to the Swift `Error` protocol,
/// allowing it to be used in throwing/catching. It also conforms to `Codable` and `Equatable` for easy encoding, decoding, and comparison.
public class ErrorFault: Error, Codable, Equatable {
    /// Optional data containing detailed information about the error.
    public var data: DataErrorFault?
    
    /// Compares two `ErrorFault` instances for equality based on their `data` properties.
    public static func == (lhs: ErrorFault, rhs: ErrorFault) -> Bool {
        return lhs.data == rhs.data
    }
    
    /// Factory method to create a new `ErrorFault` instance with specified error code, type, and message.
    /// - Parameters:
    ///   - code: The error code. Defaults to 499.
    ///   - type: The type of error. Defaults to "Unknown Error".
    ///   - message: A descriptive message for the error. Defaults to "There is an unknown error occurring."
    /// - Returns: An `ErrorFault` instance containing the specified error information.
    public static func create(
        code: Int = 499,
        type: String = "Unknown Error",
        message: String = "There is an unknown error occurring."
    ) -> ErrorFault {
        let dataFault = DataErrorFault(code: code, type: type, message: message)
        let errorFault = ErrorFault()
        errorFault.data = dataFault
        return errorFault
    }
}

/// Extension of the `Error` protocol to include a method for creating an `ErrorFault` instance representing HTTP errors.
public extension Error {
    /// Creates an `ErrorFault` instance representing an HTTP error from the current error.
    /// - Parameter code: The HTTP error code.
    /// - Returns: An `ErrorFault` instance with the current error's description and specified HTTP code.
    func asHTTPError(code: Int) -> ErrorFault {
        let dataFault = DataErrorFault(code: code, type: "HttpError", message: self.localizedDescription)
        let errorFault = ErrorFault()
        errorFault.data = dataFault
        return errorFault
    }
}

/// Extension for the `Result` type to map errors to `ErrorFault` instances, specifically for HTTP error handling.
public extension Result {
    /// Maps the `Error` in a `Result` type to an `ErrorFault`, allowing for standardized error handling in HTTP requests.
    var mapAsHTTPError: Result<Success, ErrorFault> {
        self.mapError { $0.asHTTPError(code: 499) }
    }
}
