public struct GraphNode<T: Hashable> {
    var id : T
    var links : [T]
    
    public init(id: T, links: [T]) {
        self.id = id
        self.links = links
    }
}

public struct Graph<T: Hashable> {
    var nodes: [T: [T]]
    
    public init() {
        self.nodes = [T: [T]]()
    }
    
    public init(_ nodes: [GraphNode<T>]) {
        self.nodes = [T: [T]]()
        nodes.forEach({ self.add(node: $0) })
    }
    
    public func elements() -> [T] {
        return [T](nodes.keys)
    }
    
    public mutating func add(node: GraphNode<T>) {
        nodes[node.id] = node.links
    }
    
    public func reachableFrom(_ node: T) -> Set<T> {
        var reachable = Set<T>()
        var horizon = [node]
        while !horizon.isEmpty {
            let node = horizon.popLast()!
            if !reachable.contains(node) {
                reachable.insert(node)
                nodes[node]!.forEach({ horizon.append($0) })
            }
        }
        return reachable
    }
}
