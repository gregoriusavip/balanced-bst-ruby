# frozen_string_literal: true

require_relative('lib/bst')

test_tree = Tree.new((Array.new(15) { rand(1..100) }))
p test_tree.balanced?
p test_tree.inorder
p test_tree.postorder
p test_tree.preorder
5.times { test_tree.insert(rand(100..1000)) }
p test_tree.balanced?
test_tree.rebalance
p test_tree.balanced?
test_tree.inorder { |node| print "#{node.data} " }
puts
test_tree.postorder { |node| print "#{node.data} " }
puts
test_tree.preorder { |node| print "#{node.data} " }
puts
