# frozen_string_literal: true

require_relative('node')

# A balanced binary search tree
class Tree # rubocop:disable Metrics/ClassLength
  attr_reader :root

  def initialize(arr)
    self.root = build_tree(arr.uniq.sort)
    pretty_print
  end

  def insert(value)
    new_node = Node.new(value)
    root.nil? ? @root = new_node : insert_helper(new_node)
  end

  def delete(value)
    find_node = Node.new(value)
    return find_node if root.nil?

    delete_helper(find_node)
  end

  def find(value)
    find_node = Node.new(value)
    return nil if root.nil?

    find_helper(find_node)
  end

  def level_order_iterative
    return nil if @root.nil?

    queue = [@root]
    res = []
    until queue.empty?
      cur_node = queue.shift
      block_given? ? yield(cur_node) : res << cur_node.data
      queue_next_nodes(queue, cur_node)
    end
    res
  end

  def level_order_recursive(queue = [@root], res = [], &block)
    return res if queue.empty? || @root.nil?

    cur_node = queue.shift
    block_given? ? yield(cur_node) : res << cur_node.data
    queue_next_nodes(queue, cur_node)
    level_order_recursive(queue, res, &block)
  end

  def inorder(node = @root, res = [], &block)
    return res unless node

    inorder(node.left, res, &block)
    block_given? ? yield(node) : res << node.data
    inorder(node.right, res, &block)
  end

  def preorder(node = @root, res = [], &block)
    return res unless node

    block_given? ? yield(node) : res << node.data
    preorder(node.left, res, &block)
    preorder(node.right, res, &block)
  end

  def postorder(node = @root, res = [], &block)
    return res unless node

    postorder(node.left, res, &block)
    postorder(node.right, res, &block)
    block_given? ? yield(node) : res << node.data
  end

  def height(node = @root)
    return 0 if node.nil?

    height_helper([node, nil], 0)
  end

  def depth(value)
    find_node = Node.new(value)
    return nil if root.nil?

    find_depth(find_node)
  end

  def balanced?
    return true if root.nil? || root.leaf?

    left = height(root.left)
    right = height(root.right)

    (left - right).abs <= 1
  end

  def pretty_print(node = @root, prefix = '', is_left = true) # rubocop:disable Style/OptionalBooleanParameter
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  # takes sorted arr without duplicates
  def build_tree(arr)
    return if arr.empty?

    mid = arr.length / 2
    Node.new(arr[mid], build_tree(arr[...mid]), build_tree(arr[mid + 1..]))
  end

  def insert_helper(new_node, cur_node = root)
    return cur_node if cur_node == new_node

    if new_node < cur_node
      cur_node.left.nil? ? cur_node.left = new_node : insert_helper(new_node, cur_node.left)
    else
      cur_node.right.nil? ? cur_node.right = new_node : insert_helper(new_node, cur_node.right)
    end
  end

  def delete_helper(new_node, prev_node = nil, cur_node = root, is_left: true)
    return delete_node(prev_node, cur_node, is_left) if cur_node == new_node

    return delete_helper(new_node, cur_node, cur_node.left) if new_node < cur_node && !cur_node.left.nil?

    delete_helper(new_node, cur_node, cur_node.right, is_left: false) if new_node > cur_node && !cur_node.right.nil?
  end

  def delete_node(prev_node, cur_node, is_left)
    return delete_leaf_node(prev_node, is_left) if cur_node.leaf?

    return delete_one_child_node(prev_node, cur_node, is_left) unless cur_node.left && cur_node.right

    delete_two_children_node(cur_node, cur_node.right, false)
  end

  def delete_leaf_node(prev_node, is_left)
    return self.root = nil if prev_node.nil?

    is_left ? prev_node.left = nil : prev_node.right = nil
  end

  def delete_one_child_node(prev_node, cur_node, is_left)
    next_node = cur_node.left || cur_node.right
    return self.root = next_node if prev_node.nil?

    is_left ? prev_node.left = next_node : prev_node.right = next_node
  end

  def delete_two_children_node(cur_node, min_node, is_left, min_parent = cur_node)
    if min_node.left.nil?
      cur_node.data = min_node.data
      return is_left ? min_parent.left = nil : min_parent.right = nil
    end

    delete_two_children_node(cur_node, min_node.left, true, min_node)
  end

  def find_helper(target_node, node = @root)
    return node if node == target_node

    return find_helper(target_node, node.left) if target_node < node && !node.left.nil?
    return find_helper(target_node, node.right) if target_node > node && !node.right.nil?

    nil
  end

  def find_depth(target_node, counter = 0, node = @root)
    return counter + 1 if node == target_node

    return find_depth(target_node, counter + 1, node.left) if target_node < node && !node.left.nil?
    return find_depth(target_node, counter + 1, node.right) if target_node > node && !node.right.nil?

    nil
  end

  def queue_next_nodes(queue, cur_node)
    queue << cur_node.left unless cur_node.left.nil?
    queue << cur_node.right unless cur_node.right.nil?
  end

  def height_helper(queue, depth)
    until queue.empty?
      cur_node = queue.shift
      if cur_node.nil?
        depth += 1
        queue.empty? ? (return depth) : queue << nil
      end
      queue_next_nodes(queue, cur_node) unless cur_node.nil?
    end
  end

  attr_writer :root
end
