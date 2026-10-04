import DXFeedFramework

/// Publishes a quote to a local hub and reads the last quotes back (getLastEvent and getLastEvents).
public enum SpmSmoke {
    public static func lastQuotes(symbol: String, askPrice: Double) throws -> (Quote?, [Quote?]) {
        let endpoint = try DXEndpoint.create(.localHub)
        defer { try? endpoint.closeAndAwaitTermination() }
        guard let feed = endpoint.getFeed(), let publisher = endpoint.getPublisher() else {
            return (nil, [])
        }
        let subscription = try feed.createSubscription(Quote.self)
        try subscription.addSymbols(symbol)
        let quote = Quote(symbol)
        quote.askPrice = askPrice
        try publisher.publish(events: [quote])
        let last = try feed.getLastEvent(type: Quote(symbol)) as? Quote
        // The second symbol is not subscribed: its last event is not available.
        let lasts = try feed.getLastEvents(types: [Quote(symbol), Quote(symbol + "_NONE")]).map { $0 as? Quote }
        return (last, lasts)
    }
}
