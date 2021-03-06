import Foundation

struct PluginMetadata {
    let name: String?
    let version: String?
    let author: String?
    let github: String?
    let desc: String?
    let previewImageURL: URL?
    let dependencies: [String]?
    let aboutURL: URL?
    let hideAbout: Bool
    let hideRunInTerminal: Bool
    let hideLastUpdated: Bool
    let hideDisablePlugin: Bool
    let hideSwiftBar: Bool

    var isEmpty: Bool {
        return name == nil
        && version == nil
        && author == nil
        && github == nil
        && desc == nil
        && previewImageURL == nil
        && dependencies == nil
        && aboutURL == nil
    }

    init(name: String? = nil, version: String? = nil, author: String? = nil, github: String? = nil, desc: String? = nil, previewImageURL: URL? = nil, dependencies: [String]? = nil, aboutURL: URL? = nil, hideAbout: Bool = false, hideRunInTerminal: Bool = false, hideLastUpdated: Bool = false, hideDisablePlugin: Bool = false, hideSwiftBar: Bool = false) {
        self.name = name
        self.version = version
        self.author = author
        self.github = github
        self.desc = desc
        self.previewImageURL = previewImageURL
        self.dependencies = dependencies
        self.aboutURL = aboutURL
        self.hideAbout = hideAbout
        self.hideRunInTerminal = hideRunInTerminal
        self.hideLastUpdated = hideLastUpdated
        self.hideDisablePlugin = hideDisablePlugin
        self.hideSwiftBar = hideSwiftBar
    }

    static func parser(script: String) -> Self {
        func getTagValue(tag: String, prefix: String) -> String? {
            let openTag = "<\(prefix).\(tag)>"
            let closeTag = "</\(prefix).\(tag)>"
            return script.slice(from: openTag, to: closeTag)
        }
        func getBitBarTagValue(tag: String) -> String? {
            getTagValue(tag: tag, prefix: "bitbar")
        }
        func getSwiftBarTagValue(tag: String) -> String? {
            getTagValue(tag: tag, prefix: "swiftbar")
        }
        var imageURL: URL? = nil
        if let imageStr = getBitBarTagValue(tag: "image") {
            imageURL = URL(string: imageStr)
        }
        var aboutURL: URL? = nil
        if let imageStr = getBitBarTagValue(tag: "about") {
            aboutURL = URL(string: imageStr)
        }
        return PluginMetadata(name: getBitBarTagValue(tag: "title"),
                              version: getBitBarTagValue(tag: "version"),
                              author: getBitBarTagValue(tag: "author"),
                              github: getBitBarTagValue(tag: "github"),
                              desc: getBitBarTagValue(tag: "desc"),
                              previewImageURL: imageURL,
                              dependencies: getBitBarTagValue(tag: "dependencies")?.components(separatedBy: ","),
                              aboutURL: aboutURL,
                              hideAbout: getSwiftBarTagValue(tag: "hideAbout") == "true",
                              hideRunInTerminal: getSwiftBarTagValue(tag: "hideRunInTerminal") == "true",
                              hideLastUpdated: getSwiftBarTagValue(tag: "hideLastUpdated") == "true",
                              hideDisablePlugin: getSwiftBarTagValue(tag: "hideDisablePlugin") == "true",
                              hideSwiftBar: getSwiftBarTagValue(tag: "hideSwiftBar") == "true")
    }
}

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
