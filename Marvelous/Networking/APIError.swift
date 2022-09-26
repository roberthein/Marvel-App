import Foundation

enum APIError: Error {
    case invalidURLComponents
    case invalidURL
    case invalidURLResponse
    case statusCode(Int)
    case notConnectedToInternet
    case noData
    case notImageData
    case imageNotAvailable
}
