import Foundation

class Activity: Identifiable, Codable{
    var name: String
    var description: String
    var rating: Int
    var host: String
    var photo: [String]
    var price: Double
    
    init(name: String, description: String, rating: Int, host: String, photo: [String], price: Double) {
        self.name = name
        self.description = description
        self.rating = rating
        self.host = host
        self.photo = photo
        self.price = price
    }
}
