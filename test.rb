# frozen_string_literal: true

require_relative('lib/bst')

test_tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
test_tree.insert(24)
test_tree.delete(8)
p test_tree.find(8)
