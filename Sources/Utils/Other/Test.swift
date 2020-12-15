enum TestFailure : Error {
    case Failed
}

public func test(_ condition: Bool, _ label: String) throws {
    if !condition {
        print("❌ FAILED: \(label)")
        throw TestFailure.Failed
    } else {
        print("PASSED: \(label)")
    }
}
