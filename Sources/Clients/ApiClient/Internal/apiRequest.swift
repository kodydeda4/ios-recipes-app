import Combine
import Foundation

/// Make an API request.
func apiRequest<T: Codable>(_ type: T.Type, url: String) -> AnyPublisher<T, ApiClient.Failure> {

  // Define the URL
  guard let url = URL(string: url) else {
    return Fail(error: ApiClient.Failure()).eraseToAnyPublisher()
  }

  // Fetch and decode the data
  return URLSession.shared.dataTaskPublisher(for: url)
    .mapError { error in
      print(error.localizedDescription)
      return ApiClient.Failure()
    }
    .flatMap { data, response -> AnyPublisher<T, ApiClient.Failure> in
      // Decode the JSON response to ApiClient.Meal
      let decoder = JSONDecoder()
      return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
          print(error.localizedDescription)
          return ApiClient.Failure()
        }
        .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
}
