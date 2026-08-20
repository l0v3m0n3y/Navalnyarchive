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
    public func getDonateWallet(type: String) async throws -> Any {
        // type_list: ["bitcoin-address","monero-address"]
        guard let url = URL(string: "\(donateApi)/\(type)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [:], options: [])
    
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getEditorialsList(lang: String = "ru", limit: Int) async throws -> Any {
        let urlString = "\(api)/\(lang)/editorials/?limit=\(limit)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func getDailyPostsToday(lang: String = "ru") async throws -> Any {
        let urlString = "\(api)/\(lang)/daily-posts/today/"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getPeopleList(lang: String = "ru") async throws -> Any {
        let urlString = "\(api)/\(lang)/people/"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getTagsList(lang: String = "ru") async throws -> Any {
        let urlString = "\(api)/\(lang)/tags/"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func getMaterialsList(lang: String = "ru", pageSize: Int) async throws -> Any {
        let urlString = "\(api)/\(lang)/materials/?page_size=\(pageSize)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func getHomeContent(lang: String = "ru") async throws -> Any {
        let urlString = "\(api)/\(lang)/home-content/"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func getMaterialsStatistics(formats: String? = nil, types: String? = nil) async throws -> Any {
        guard var components = URLComponents(string: "\(api)/materials/statistics/") else {
            throw URLError(.badURL)
        }
        var queryItems: [URLQueryItem] = []
        if let formats = formats {
            queryItems.append(URLQueryItem(name: "formats", value: formats))
        }
        if let types = types {
            queryItems.append(URLQueryItem(name: "types", value: types))
        }
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func getRelatedMaterialById(lang: String = "ru", materialId: Int) async throws -> Any {
        let urlString = "\(api)/\(lang)/materials/\(materialId)/related/"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func getMaterialById(lang: String = "ru", materialId: Int) async throws -> Any {
        let urlString = "\(api)/\(lang)/materials/\(materialId)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func getWikiPage(name: String,bildId: String = "K8H6W351Ekktz1chHY1vH",lang: String = "ru") async throws -> Any {
        let urlString = "\(wikiApi)/\(bildId)/\(lang)/\(name).json"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
}
