import Combine
import Foundation

public struct ApiClient {
  public var fetchAllMealCategories: () -> AnyPublisher<[MealCategory], Failure>
  public var fetchAllMeals: (MealCategory) -> AnyPublisher<[Meal], Failure>
  public var fetchMealDetailsById: (Meal.ID) -> AnyPublisher<[MealDetails], Failure>

  public static var liveValue = Self(
    fetchAllMealCategories: {
      struct Response: Codable {
        let categories: [ApiClient.MealCategory]
      }
      return apiRequest(
        Response.self,
        url: "https://www.themealdb.com/api/json/v1/1/categories.php"
      )
      .map { $0.categories }
      .eraseToAnyPublisher()

    },
    fetchAllMeals: { category in
      struct Response: Codable {
        let meals: [ApiClient.Meal]
      }
      return apiRequest(
        Response.self,
        url: "https://themealdb.com/api/json/v1/1/filter.php?c=\(category.strCategory)"
      )
      .map { $0.meals }
      .eraseToAnyPublisher()
    },
    fetchMealDetailsById: { id in
      struct Response: Codable {
        let meals: [ApiClient.MealDetails]
      }
      return apiRequest(
        Response.self,
        url: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
      )
      .map { $0.meals }
      .eraseToAnyPublisher()
    }
  )
}

