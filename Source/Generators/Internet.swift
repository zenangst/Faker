import Foundation

public class Internet: Generator {

  let lorem: Lorem

  public required init(parser: Parser) {
    self.lorem = Lorem(parser: parser)
    super.init(parser: parser)
  }

  public func username(separator: String? = nil) -> String {
    var components: [String] = [
      generate("name.first_name"),
      generate("name.last_name"),
      "\(arc4random_uniform(10000))"
    ]

    let randomCount = UInt32(components.count) - 1
    let count = Int(arc4random_uniform(randomCount) + randomCount)

    var gap = ""
    if let sep = separator {
      gap = sep
    }
    return gap.join(components[0..<count]).stringByReplacingOccurrencesOfString("'", withString: "").lowercaseString
  }

  public func domainName(alphaNumericOnly: Bool = true) -> String {
    return domainWord(alphaNumericOnly: alphaNumericOnly) + "." + domainSuffix()
  }

  public func domainWord(alphaNumericOnly: Bool = true) -> String {
    var nameParts = split(generate("company.name")) {$0 == " "}
    var name = ""
    if let first = nameParts.first {
      name = first
    } else {
      name = letterify("?????")
    }

    let result = alphaNumericOnly ? alphaNumerify(name) : name
    return result.lowercaseString
  }

  public func domainSuffix() -> String {
    return generate("internet.domain_suffix")
  }

  public func email() -> String {
    return "@".join([username(), domainName()])
  }

  public func freeEmail() -> String {
    return "@".join([username(), generate("internet.free_email")])
  }

  public func safeEmail() -> String {
    let topLevelDomains = ["org", "com", "net"]
    let count = UInt32(topLevelDomains.count)
    let topLevelDomain = topLevelDomains[Int(arc4random_uniform(count))]

    return "@".join([username(), "example." + topLevelDomain])
  }

  public func password(minimumLength: Int = 8, maximumLength: Int = 16) -> String {
    var temp = lorem.characters(amount: minimumLength)
    let diffLength = maximumLength - minimumLength
    if diffLength > 0 {
      let diffRandom = Int(arc4random_uniform(UInt32(diffLength + 1)))
      temp += lorem.characters(amount: diffRandom)
    }
    return temp
  }

  public func ipV4Address() -> String {
    let ipRand = {
      2 + arc4random() % 253
    }

    return String(format: "%d.%d.%d.%d", ipRand(), ipRand(), ipRand(), ipRand())
  }

  public func ipV6Address() -> String {
    var components: [String] = []

    for _ in 1..<8 {
      components.append(String(format: "%X", arc4random() % 65535))
    }

    return ":".join(components)
  }

  public func url() -> String {
    return "http://\(domainName())/\(username())"
  }

  // @ToDo - slug
}
