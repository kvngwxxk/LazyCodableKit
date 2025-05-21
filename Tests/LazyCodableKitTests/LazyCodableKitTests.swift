import Testing
import Foundation

@testable import LazyCodableKit

struct PromisedIntTests {
    @Test func decodeVariousTypes() throws {
        struct Model: Decodable {
            @PromisedInt var value: Int
        }
        
        LazyCodableLogger.isEnabled = true
        LazyCodableLogger.logOnSuccess = true
        
        let jsonInt = #"{"value": 123}"#.data(using: .utf8)!
        let decodedInt = try JSONDecoder().decode(Model.self, from: jsonInt)
        #expect(decodedInt.value == 123)
        
        let jsonStr = #"{"value": "456"}"#.data(using: .utf8)!
        let decodedStr = try JSONDecoder().decode(Model.self, from: jsonStr)
        #expect(decodedStr.value == 456)
        
        let jsonDouble = #"{"value": 789.99}"#.data(using: .utf8)!
        let decodedDouble = try JSONDecoder().decode(Model.self, from: jsonDouble)
        #expect(decodedDouble.value == 789)
    }
}

struct PromisedStringTests {
    @Test func decodeVariousTypesToString() throws {
        struct Model: Decodable {
            @PromisedString var name: String
        }
        
        LazyCodableLogger.isEnabled = true
        LazyCodableLogger.logOnSuccess = true
        
        let jsonStr = #"{"name": "Alice"}"#.data(using: .utf8)!
        let model1 = try JSONDecoder().decode(Model.self, from: jsonStr)
        #expect(model1.name == "Alice")
        
        let jsonInt = #"{"name": 123}"#.data(using: .utf8)!
        let model2 = try JSONDecoder().decode(Model.self, from: jsonInt)
        #expect(model2.name == "123")
        
        let jsonBool = #"{"name": true}"#.data(using: .utf8)!
        let model3 = try JSONDecoder().decode(Model.self, from: jsonBool)
        #expect(model3.name == "true")
        
        let jsonNull = #"{"name": null}"#.data(using: .utf8)!
        let model4 = try JSONDecoder().decode(Model.self, from: jsonNull)
        #expect(model4.name == "")
        
        let jsonEmpty = #"{"name": {}}"#.data(using: .utf8)!
        let model5 = try JSONDecoder().decode(Model.self, from: jsonEmpty)
        #expect(model5.name == "")
    }
}

struct PromisedBoolTests {
    @Test func decodeVariousValuesToBool() throws {
        struct Model: Decodable {
            @PromisedBool var isActive: Bool
        }
        
        LazyCodableLogger.isEnabled = true
        LazyCodableLogger.logOnSuccess = true
        
        #expect(try JSONDecoder().decode(Model.self, from: #"{"isActive": true}"#.data(using: .utf8)!).isActive == true)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"isActive": "true"}"#.data(using: .utf8)!).isActive == true)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"isActive": 1}"#.data(using: .utf8)!).isActive == true)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"isActive": "yes"}"#.data(using: .utf8)!).isActive == true)
        
        #expect(try JSONDecoder().decode(Model.self, from: #"{"isActive": false}"#.data(using: .utf8)!).isActive == false)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"isActive": "false"}"#.data(using: .utf8)!).isActive == false)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"isActive": 0}"#.data(using: .utf8)!).isActive == false)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"isActive": "no"}"#.data(using: .utf8)!).isActive == false)
        
        #expect(try JSONDecoder().decode(Model.self, from: #"{"isActive": null}"#.data(using: .utf8)!).isActive == false)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"isActive": "garbage"}"#.data(using: .utf8)!).isActive == false)
    }
}


struct PromisedDoubleTests {
    @Test func decodeVariousTypesToDouble() throws {
        struct Model: Decodable {
            @PromisedDouble var price: Double
        }
        
        LazyCodableLogger.isEnabled = true
        LazyCodableLogger.logOnSuccess = true
        
        #expect(try JSONDecoder().decode(Model.self, from: #"{"price": 123}"#.data(using: .utf8)!).price == 123.0)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"price": "456.78"}"#.data(using: .utf8)!).price == 456.78)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"price": true}"#.data(using: .utf8)!).price == 1.0)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"price": false}"#.data(using: .utf8)!).price == 0.0)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"price": null}"#.data(using: .utf8)!).price == -1.0)
    }
}

struct PromisedOptionalIntTests {
    @Test func decodesVariousTypesCorrectly() throws {
        struct Model: Decodable {
            @PromisedOptionalInt var value: Int?
        }
        
        LazyCodableLogger.isEnabled = true
        LazyCodableLogger.logOnSuccess = true
        
        #expect(try JSONDecoder().decode(Model.self, from: #"{"value": 123}"#.data(using: .utf8)!).value == 123)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"value": "456"}"#.data(using: .utf8)!).value == 456)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"value": 789.99}"#.data(using: .utf8)!).value == 789)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"value": null}"#.data(using: .utf8)!).value == nil)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"value": {}}"#.data(using: .utf8)!).value == nil)
    }
}

struct PromisedOptionalBoolTests {
    @Test func decodesVariousFormatsToBool() throws {
        struct Model: Decodable {
            @PromisedOptionalBool var flag: Bool?
        }
        
        LazyCodableLogger.isEnabled = true
        LazyCodableLogger.logOnSuccess = true
        
        #expect(try JSONDecoder().decode(Model.self, from: #"{"flag": true}"#.data(using: .utf8)!).flag == true)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"flag": 1}"#.data(using: .utf8)!).flag == true)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"flag": "yes"}"#.data(using: .utf8)!).flag == true)
        
        #expect(try JSONDecoder().decode(Model.self, from: #"{"flag": false}"#.data(using: .utf8)!).flag == false)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"flag": "no"}"#.data(using: .utf8)!).flag == false)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"flag": null}"#.data(using: .utf8)!).flag == nil)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"flag": {}}"#.data(using: .utf8)!).flag == nil)
    }
}


struct PromisedOptionalStringTests {
    @Test func decodesMixedTypesToString() throws {
        struct Model: Decodable {
            @PromisedOptionalString var name: String?
        }
        
        LazyCodableLogger.isEnabled = true
        LazyCodableLogger.logOnSuccess = true
        
        #expect(try JSONDecoder().decode(Model.self, from: #"{"name": "Alice"}"#.data(using: .utf8)!).name == "Alice")
        #expect(try JSONDecoder().decode(Model.self, from: #"{"name": 123}"#.data(using: .utf8)!).name == "123")
        #expect(try JSONDecoder().decode(Model.self, from: #"{"name": 456.78}"#.data(using: .utf8)!).name == "456.78")
        #expect(try JSONDecoder().decode(Model.self, from: #"{"name": true}"#.data(using: .utf8)!).name == "true")
        #expect(try JSONDecoder().decode(Model.self, from: #"{"name": null}"#.data(using: .utf8)!).name == nil)
    }
}

struct PromisedOptionalDoubleTests {
    @Test func decodesVariousNumericFormats() throws {
        struct Model: Decodable {
            @PromisedOptionalDouble var amount: Double?
        }
        
        LazyCodableLogger.isEnabled = true
        LazyCodableLogger.logOnSuccess = true
        
        #expect(try JSONDecoder().decode(Model.self, from: #"{"amount": 123.45}"#.data(using: .utf8)!).amount == 123.45)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"amount": 456}"#.data(using: .utf8)!).amount == 456.0)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"amount": "789.99"}"#.data(using: .utf8)!).amount == 789.99)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"amount": true}"#.data(using: .utf8)!).amount == 1.0)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"amount": false}"#.data(using: .utf8)!).amount == 0.0)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"amount": null}"#.data(using: .utf8)!).amount == nil)
        #expect(try JSONDecoder().decode(Model.self, from: #"{"amount": {}}"#.data(using: .utf8)!).amount == nil)
    }
}
