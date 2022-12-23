struct ConfigurationModel {
    struct Headers {
        var environment: String = "test"
        var project = "DSL"
        var contentType = "application/json"
        var accept = "application/json"
    }
    var baseUrl = ""
    var headers = Headers()
    var optionalHeaders: [String: String]?
    
    public mutating func optionalHeaders(_ configurations: (inout [String: String]) -> Void) {
        var userProvidedHeaders: [String: String] = [:]
        configurations(&userProvidedHeaders)
        self.optionalHeaders = userProvidedHeaders
    }
    
    public mutating func headers(_ configurations: (inout Headers) -> Void) {
        var staticHeaders = Headers()
        configurations(&staticHeaders)
        self.headers = staticHeaders
    }
    
    public mutating func baseUrl(_ configurations: () -> String) {
        baseUrl = configurations()
    }
    
    public var allHeaders: [String: String] {
        var headersDictionary = [
            "vf-target-environment": headers.environment,
            "vf-project": headers.project,
            "Content-Type": headers.contentType,
            "Accept": headers.accept
        ]
        
        optionalHeaders?.forEach { key, value in
            headersDictionary[key] = value
        }
        return headersDictionary
    }
}

class RequestConfiguration {
    static var model = ConfigurationModel()
    static func apply(_ configurations: (inout ConfigurationModel) -> Void) {
        configurations(&model)
    }
}


RequestConfiguration.apply {
    $0.baseUrl {
        "https://wiki.com"
    }
    $0.headers {
        $0.environment = "Test"
    }
    $0.optionalHeaders {
        $0["optional-key"] = "optional-value"
    }
}

RequestConfiguration.model.allHeaders.forEach { element in
    print(element)
}

print(RequestConfiguration.model.baseUrl)
