import Vapor

public final class Provider: Vapor.Provider {
  public static let repositoryName: String = "healthcheck-provider"
  public var healthCheckUrl: String?

  public init(config: Config) throws {
    if let healthCheckUrl = config["healthcheck", "url"]?.string {
      self.healthCheckUrl = healthCheckUrl
    }
  }

  public func boot(_ config: Config) throws {}

  public func boot(_ drop: Droplet) {
    guard let healthCheckUrl = self.healthCheckUrl else {
      return drop.console.warning("MISSING: healthcheck.json config in Config folder. Healthcheck URL not addded.")
    }

    drop.get(healthCheckUrl) { req in
      return try Response(status: .ok, json: JSON(["status": "up"]))
    }

  }

  public func beforeRun(_ drop: Droplet) {}
}
