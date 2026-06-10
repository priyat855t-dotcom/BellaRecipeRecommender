//
//  Extensions.swift
//  BellaRecipeRecommender
//
//  Helpful extensions for common operations
//

import SwiftUI

extension String {
    var isValidIngredient: Bool {
        let trimmed = self.trimmingCharacters(in: .whitespaces)
        return !trimmed.isEmpty && trimmed.count >= 2
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Color {
    static let beigeBackground = Color(#colorLiteral(red: 0.95, green: 0.93, blue: 0.88, alpha: 1))
    static let accentOrange = Color(#colorLiteral(red: 0.98, green: 0.54, blue: 0.13, alpha: 1))
}

extension URLSession {
    func cachedData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let (data, response) = try await self.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
