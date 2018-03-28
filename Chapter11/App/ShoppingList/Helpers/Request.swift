import Foundation

let baseUrl = Bundle.main.infoDictionary!["BaseURL"]!

func request(url: String, httpMethod: String = "GET", httpBody: Data? = .none, httpHeaders: [String: String] = [String: String](), completionHandler: @escaping (Data?, URLResponse?, Error?) throws -> Void) {
  var request = URLRequest(url: URL(string: "\(baseUrl)\(url)")!)
  var headers = httpHeaders
  if let data = UserDefaults.standard.value(forKey: String(describing: Token.self)) as? Data,
    let token = try? PropertyListDecoder().decode(Token.self, from: data) {
    headers["Authorization"] = "Bearer \(token.token)"
  }

  request.httpMethod = httpMethod
  if let data = httpBody {
    request.httpBody = data
    headers["content-type"] = "application/json"
  }
  request.allHTTPHeaderFields = headers
  URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
    DispatchQueue.main.async {
      do {
        try completionHandler(data, response, error)
      } catch {}
    }
  }).resume()
}
