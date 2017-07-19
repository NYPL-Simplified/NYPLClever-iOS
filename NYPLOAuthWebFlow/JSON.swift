import Foundation

/// Utility methods for JSON objects.
final class JSON {

  /// Given an object and a path, returns the object at the given path, if any.
  ///
  /// ```
  /// JSON.get(["a": ["b": "c"]], path: ["a", "b"]) == "c"
  /// ```
  static func get(_ object: Any, path: [String]) -> Any? {
    var object = object
    for key in path {
      if let dict = object as? [String: Any], let value = dict[key] {
        object = value
      } else {
        return nil
      }
    }
    return object
  }
}
