import Foundation

func toJSON<T: Encodable>(_ object: T) -> Data? {
     let encoder = JSONEncoder()
     encoder.outputFormatting = .prettyPrinted
     do {
         let jsonData = try encoder.encode(object)
         return jsonData
     } catch {
         print("Error encoding object to JSON: \(error)")
         return nil
     }
 }
