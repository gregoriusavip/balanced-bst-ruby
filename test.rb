# frozen_string_literal: true

require_relative('lib/bst')

test_tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
test_tree.insert(10_000)
test_tree.insert(10_001)
test_tree.insert(10_000)
test_tree.insert(10_002)
test_tree.pretty_print
p test_tree.inorder
p test_tree.balanced?
test_tree.rebalance
p test_tree.inorder
p test_tree.balanced?
