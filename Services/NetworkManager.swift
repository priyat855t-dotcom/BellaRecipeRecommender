//
//  NetworkManager.swift
//  BellaRecipeRecommender
//
//  Handles all network requests
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    enum NetworkError: LocalizedError {
        case invalidURL
        case invalidResponse
        case decodingError
        case networkError(Error)
        case noData
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The URL is invalid"
            case .invalidResponse:
                return "Invalid response from server"
            case .decodingError:
                return "Failed to decode response"
            case .networkError(let error):
                return error.localizedDescription
            case .noData:
                return "No data received from server"
            }
        }
    }
    
    func fetch<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    func fetchData(url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
}
