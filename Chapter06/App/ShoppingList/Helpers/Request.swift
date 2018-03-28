import Foundation

let baseUrl = Bundle.main.infoDictionary!["BaseURL"]!

func request(url: String, httpMethod: String = "GET", httpBody: Data? = .none, completionHandler: @escaping (Data?, URLResponse?, Error?) throws -> Void) {
  var request = URLRequest(url: URL(string: "\(baseUrl)\(url)")!)
  request.httpMethod = httpMethod
  if let data = httpBody {
    request.httpBody = data
    request.allHTTPHeaderFields = [
      "content-type": "application/json"
    ]
  }
  URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
    DispatchQueue.main.async {
      do {
        try completionHandler(data, response, error)
      } catch {}
    }
  }).resume()
}
