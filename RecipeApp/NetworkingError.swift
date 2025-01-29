//
//  NetworkingError.swift
//  RecipeApp
//
//  Created by Christian Apfler on 15.12.24.
//

enum NetworkingError: Error ,Sendable{
    case invalidURL
    case networkOffline
    case unknownError(String)
    case invalidResponse
    case noData
    case unableToDecodeError(String)
    case firebaseError(String, [String])
    case jsonSerializationError(Error)
    case invalidToken
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .networkOffline:
            return "You are offline. Please check your internet connection."
        case .unknownError(let message):
            return "Unknown error: \(message)"
        case .invalidResponse:
            return "The server returned an invalid response."
        case .noData:
            return "No data received from the server."
        case .unableToDecodeError(let message):
            return "Failed to decode response: \(message)"
        case .firebaseError(let message, _):
            return "Firebase error: \(message)"
        case .jsonSerializationError(let error):
            return "JSON serialization error: \(error.localizedDescription)"
        case .invalidToken:
            return "The provided token is invalid."
        }
    }
}
