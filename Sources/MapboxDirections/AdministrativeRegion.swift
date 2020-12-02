import Foundation

/**
 `AdministrativeRegion` describes corresponding object on the route.
 */
public struct AdministrativeRegion: Codable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case countryCodeAlpha3 = "iso_3166_1_alpha3"
        case countryCode = "iso_3166_1"
    }

    /// ISO 3166-1 alpha-3 country code
    public var countryCodeAlpha3: String?
    /// ISO 3166-1 country code
    public var countryCode: String

    public init(countryCode: String, countryCodeAlpha3: String) {
        self.countryCode = countryCode
        self.countryCodeAlpha3 = countryCodeAlpha3
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        countryCode = try container.decode(String.self, forKey: .countryCode)
        countryCodeAlpha3 = try container.decodeIfPresent(String.self, forKey: .countryCodeAlpha3)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(countryCodeAlpha3, forKey: .countryCodeAlpha3)
    }
}
