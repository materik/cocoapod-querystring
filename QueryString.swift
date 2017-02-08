
import UIKit

public struct QueryString {

    private let keyValueSep: String = "="
    private let querySep: String = "&"
    private let queryStart: String = "?"

    private var values: [String: String] = [:]

    public init() {}

    public mutating func add(key: String, value: String) {
        self.values[key] = value.addingPercentEncoding(
            withAllowedCharacters: NSCharacterSet.urlQueryAllowed
        )
    }

    public func append(to path: String) -> String {
        guard self.queryString.contains(self.keyValueSep) else {
            return path
        }
        var sep = path.contains(self.queryStart) ? self.querySep : self.queryStart
        // NOTE(materik):
        // * wierd check, would like to parse query strings from path and append to that
        sep = path.characters.last == "?" ? "" : sep
        return "\(path)\(sep)\(self.queryString)"
    }

    fileprivate var queryString: String {
        var values: [String] = []
        for (key, value) in self.values {
            values.append("\(key)\(self.keyValueSep)\(value)")
        }
        return values.joined(separator: self.querySep)
    }

}

extension QueryString: CustomStringConvertible {

    public var description: String {
        return self.queryString
    }

}
