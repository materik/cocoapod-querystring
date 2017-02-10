
import UIKit

public struct QueryString {

    private let keyValueSep: String = "="
    private let querySep: String = "&"
    private let queryStart: String = "?"

    fileprivate var values: [String: String] = [:]

    public init() {}
    
    public init?(path: String) {
        let components = path.components(separatedBy: self.queryStart)
        guard components.count == 2, let queryStrings = components.last else {
            return nil
        }
        
        let queries = queryStrings.components(separatedBy: self.querySep)
        for query in queries {
            let keyValue = query.components(separatedBy: self.keyValueSep)
            guard keyValue.count == 2, let key = keyValue.first, let value = keyValue.last else {
                continue
            }
            
            self.add(key: key, value: value)
        }
        
        if self.values.isEmpty {
            return nil
        }
    }

    public mutating func add(key: String, value: String) {
        self.values[key] = value.addingPercentEncoding(
            withAllowedCharacters: NSCharacterSet.urlQueryAllowed
        )
    }

    public func append(to path: String) -> String {
        guard !self.values.isEmpty else {
            return path
        }
        var queryString = QueryString(path: path) ?? QueryString()
        queryString = queryString + self
        let path = QueryString.strip(from: path)
        return "\(path)\(self.queryStart)\(queryString.queryString)"
    }

    fileprivate var queryString: String {
        var values: [String] = []
        for (key, value) in self.values {
            values.append("\(key)\(self.keyValueSep)\(value)")
        }
        return values.joined(separator: self.querySep)
    }
    
    static func strip(from path: String) -> String {
        return path.components(separatedBy: QueryString().queryStart).first!
    }

}

extension QueryString: CustomStringConvertible {

    public var description: String {
        return self.queryString
    }

}

public func + (lhs: QueryString, rhs: QueryString) -> QueryString {
    var lhs = lhs
    for (key, value) in rhs.values {
        lhs.add(key: key, value: value)
    }
    return lhs
}
