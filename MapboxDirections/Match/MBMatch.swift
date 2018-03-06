import Polyline

@objc(MBMatch)
open class Match: DirectionsResult {
    
    init(matchOptions: MatchingOptions, legs: [RouteLeg], distance: CLLocationDistance, expectedTravelTime: TimeInterval, coordinates: [CLLocationCoordinate2D]?, confidence: Double, speechLocale: Locale?) {
        self.confidence = confidence
        super.init(options: matchOptions, legs: legs, distance: distance, expectedTravelTime: expectedTravelTime, coordinates: coordinates, speechLocale: speechLocale)
    }
    
    convenience init(json: [String: Any], tracePoints: [Tracepoint], matchOptions: MatchingOptions) {
        let legInfo = zip(zip(tracePoints.prefix(upTo: tracePoints.endIndex - 1), tracePoints.suffix(from: 1)),
                          json["legs"] as? [JSONDictionary] ?? [])
        let legs = legInfo.map { (endpoints, json) -> RouteLeg in
            RouteLeg(json: json, source: endpoints.0, destination: endpoints.1, profileIdentifier: matchOptions.profileIdentifier)
        }
        
        let distance = json["distance"] as! Double
        let expectedTravelTime = json["duration"] as! Double
        
        var coordinates: [CLLocationCoordinate2D]?
        switch json["geometry"] {
        case let geometry as JSONDictionary:
            coordinates = CLLocationCoordinate2D.coordinates(geoJSON: geometry)
        case let geometry as String:
            coordinates = decodePolyline(geometry, precision: 1e5)!
        default:
            coordinates = nil
        }
        
        let confidence = json["confidence"] as! Double
        
        var speechLocale: Locale?
        if let locale = json["voiceLocale"] as? String {
            speechLocale = Locale(identifier: locale)
        }
        
        self.init(matchOptions: matchOptions, legs: legs, distance: distance, expectedTravelTime: expectedTravelTime, coordinates: coordinates, confidence: confidence, speechLocale: speechLocale)
    }
    
    /**
     A number between 0 and 1 that indicates the Map Matching API’s confidence that the match is accurate. A higher confidence means the match is more likely to be accurate.
     */
    @objc open var confidence: Float
    
    public var matchOptions: MatchingOptions {
        return super.directionsOptions as! MatchingOptions
    }
    
    @objc public required convenience init?(coder decoder: NSCoder) {
        self.init(coder: decoder)
        confidence = decoder.decodeFloat(forKey: "confidence")
    }
    
    @objc public override func encode(with coder: NSCoder) {
        coder.encode(confidence, forKey: "confidence")
    }
}
