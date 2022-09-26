import Foundation
import UIKit

protocol API {
    func fetch<T>(request: Request<T>) async throws -> Result<T, Error>
}

extension API {

    func fetch<T>(request: Request<T>) async throws -> Result<T, Error> {
        guard let components = URLComponents(string: request.url)..{
            $0?.queryItems = request.queryItems
        } else {
            throw APIError.invalidURLComponents
        }

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        let urlRequest = URLRequest(url: url)..{
            $0.httpMethod = "GET"
            $0.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        do {
            let (data, response) = try await URLSession.shared.data(
                for: urlRequest,
                delegate: nil
            )

            guard let response = response as? HTTPURLResponse else {
                throw APIError.invalidURLResponse
            }

            switch response.statusCode {
            case 200...299:
                return request.parse(data)
            default:
                throw APIError.statusCode(response.statusCode)
            }
        } catch URLError.Code.notConnectedToInternet {
            throw APIError.notConnectedToInternet
        }
    }
}
