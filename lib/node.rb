# frozen_string_literal: true

# A tree node contains its data and its left/right children
class Node
  include Comparable

  def initialize(val, left = nil, right = nil)
    self.left = left
    self.right = right
    self.data = val
  end

  def <=>(other)
    data <=> other.data
  end

  attr_accessor :left, :right, :data
end
