import FluentProvider
import HealthcheckProvider
import MongoProvider
import LeafProvider

extension Config {
  public func setup() throws {
    // allow fuzzy conversions for these types
    // (add your own types here)
    Node.fuzzy = [Row.self, JSON.self, Node.self]
    
    try setupProviders()
    try setupPreparations()
    addConfigurable(middleware: ResponseFormatterMiddleware.init, name: "response-formatter")
  }
  
  /// Configure providers
  private func setupProviders() throws {
    try addProvider(FluentProvider.Provider.self)
    try addProvider(HealthcheckProvider.Provider.self)
    try addProvider(MongoProvider.Provider.self)
    try addProvider(LeafProvider.Provider.self)
  }
  
  /// Add all models that should have their
  /// schemas prepared before the app boots
  private func setupPreparations() throws {
    preparations.append(ShoppingList.self)
    preparations.append(Item.self)
  }
}
