# frozen_string_literal: true

require_relative('node')

# A balanced binary search tree
class Tree
  def initialize(arr)
    self.root = build_tree(arr.uniq.sort)
  end

  private

  # takes sorted arr without duplicates
  def build_tree(arr)
    return if arr.empty?

    mid = arr.length / 2
    Node.new(arr[mid], build_tree(arr[...mid]), build_tree(arr[mid + 1..]))
  end

  def pretty_print(node = @root, prefix = '', is_left = true) # rubocop:disable Style/OptionalBooleanParameter
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  attr_writer :root
end
