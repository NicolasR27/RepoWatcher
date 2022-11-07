
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
    }
    
    func getRepo(atURL urlString: String) async throws -> Repository {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let(data,response) = try await URLSession.shared.data(from:url)
        
        guard let response = response as? HTTPURLResponse,response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let codingData = try decoder.decode(Repository.CodingData.self,from: data)
            return codingData.repo
        } catch {
            throw NetworkError.invalidRepoData
        }
    }
    
    func downloadImageData(from urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let(data, _) = try await URLSession.shared.data(from:url)
            return data
            
        } catch {
            return nil
        }
        
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidRepoData
}


struct RepoURL {
    static let swiftNews = "https://api.github/repos/seanallen0400/swift-news"
    static let publish = "https://api.github/repos/johnsundell/publish"
    static let google = "https://api.github/repos/GoogleSignin-iOS"
    
}
