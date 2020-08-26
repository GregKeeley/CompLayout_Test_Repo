import UIKit

// binary tree = Abstart data type
// the components of a tree are the root node, child node

// A node is referred to as a leaf if it does not have any children

//FIFO - First In First Out
// There are 2 ways to traverse a binary tree
// 1. Breadth-first traversal - uses a queue to keep track of visited nodes
// 2. Depth-First traversal: in-order, post-order, pre-order
class BinaryTreeNode<T> {
    var value: T
    var leftChild: BinaryTreeNode?
    var rightChild: BinaryTreeNode?
    init(_ value: T) {
        self.value = value
    }
}
struct Queue<T> {
    private var elements = [T]()
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    public var count: Int {
        return elements.count
    }
    public var peek: T? {
        return elements.first
    }
    // adds to element to the
    public mutating func enqueue(_ item: T) {
        elements.append(item) // O(1) - simply adds to the end, so, constant run time
    }
    public mutating func dequeue() -> T? {
        guard !isEmpty else { return nil }
        return elements.removeFirst()
    }
}
/*
        root
         
         1
        / \
       2   3
      / \
     4   5
 
 */

let rootNode = BinaryTreeNode<Int>(1)
let twoNode = BinaryTreeNode<Int>(2)
let threeNode = BinaryTreeNode<Int>(3)
let fourNode = BinaryTreeNode<Int>(4)
let fiveNode = BinaryTreeNode<Int>(5)

rootNode.leftChild = twoNode
rootNode.rightChild = threeNode
twoNode.leftChild = fourNode
twoNode.rightChild = fiveNode

extension BinaryTreeNode {
    func breadthFirstTraversal(visit: (BinaryTreeNode) -> ()) {
        var queue = Queue<BinaryTreeNode>()
        visit(self) // self represents the root node
        // visit(self) // We are capturing the parent node as opposed to printing in this method
        queue.enqueue(self)
        while let node = queue.dequeue() {
            // Check for left child and enqueue as needed
            if let leftChild = node.leftChild { // using optional binding
            visit(leftChild)
            queue.enqueue(leftChild)
            }
            // Check for right child and enqueue as needed
            if let rightChild = node.rightChild {
                visit(rightChild)
                queue.enqueue(rightChild)
            }
        }
    }
}
print("breadth-first traversal")
rootNode.breadthFirstTraversal { (node) in
    print(node.value, terminator: " ")
}
