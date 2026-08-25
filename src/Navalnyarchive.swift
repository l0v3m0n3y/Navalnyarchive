import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public class NavalnyArchive {
    private let api = "https://api-archive.navalny.com/api/v1"
    private let donateApi = "https://navalny.com/en/api"
    private let wikiApi = "https://novichok.navalny.wiki/_next/data"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
            "Accept": "*/*",
            "Connection": "keep-alive",
            "Accept-Encoding": "deflate, zstd",
            "Accept-Language": "en-US,en;q=0.9",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36"
        ]
    }
    
    private func fetchJSON(from urlString: String,method: HTTPMethod = .get,body: Data? = nil,queryParameters: [String: String]? = nil) async throws -> Any {
        var urlComponents = URLComponents(string: urlString)
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getDonateWallet(type: String) async throws -> Any {
        // type_list: ["bitcoin-address","monero-address"]
        return try await fetchJSON(from: "\(donateApi)/\(type)")
    }
    
    public func getEditorialsList(lang: String = "ru", limit: Int) async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/editorials/?limit=\(limit)")
    }

    public func getDailyPostsToday(lang: String = "ru") async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/daily-posts/today/")
    }
    
    public func getPeopleList(lang: String = "ru") async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/people/")
    }
    
    public func getTagsList(lang: String = "ru") async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/tags/")
    }

    public func getMaterialsList(lang: String = "ru", pageSize: Int) async throws -> Any {
        return try await fetchJSON(from: \(api)/\(lang)/materials/?page_size=\(pageSize)")
    }

    public func getHomeContent(lang: String = "ru") async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/home-content/")
    }

    public func getMaterialsStatistics(formats: String? = nil, types: String? = nil) async throws -> Any {
        guard var components = URLComponents(string: "\(api)/materials/statistics/") else {
            throw URLError(.badURL)
        }
        var queryParameters: [String: String] = [:]
        if let formats = formats {
            queryParameters["formats"] = formats
        }
        if let types = types {
             queryParameters["types"] = types
        }
        
        return try await fetchJSON(from: urlString,queryParameters: queryParameters.isEmpty ? nil : queryParameters)
    }

    public func getRelatedMaterialById(lang: String = "ru", materialId: Int) async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/materials/\(materialId)/related/")
    }

    public func getMaterialById(lang: String = "ru", materialId: Int) async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/materials/\(materialId)")
    }

    public func getWikiPage(name: String,bildId: String = "K8H6W351Ekktz1chHY1vH",lang: String = "ru") async throws -> Any {
        return try await fetchJSON(from: "\(wikiApi)/\(bildId)/\(lang)/\(name).json")
    }
}
