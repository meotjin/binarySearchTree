require_relative 'node'

class Tree
  attr_accessor :root

  def build_tree(array)
    sorted = array.sort.uniq
    self.root = tree(sorted)
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, data = root)
    case value <=> data.value
    when 1
      if data.right.nil?
        data.right = Node.new(value)
      else
        insert(value, data.right)
      end
    when 0
      nil
    when -1
      if data.left.nil?
        data.left = Node.new(value)
      else
        insert(value, data.left)
      end
    end
  end

  def find(value, node = root)
    return nil if node.nil?
    return node if node.value == value

    if value > node.value
      find(value, node.right)
    else
      find(value, node.left)
    end
  end

  def level_order(&block)
    queue = [root]
    values_level_order = []
    until queue.empty?
      node = queue.shift
      values_level_order.push node.value
      queue.push node.left unless node.left.nil?
      queue.push node.right unless node.right.nil?
    end
    return values_level_order unless block_given?

    values_level_order.map { |value| block.call value }
  end

  def preorder(node = root, array = [], &block)
    return if node.nil?

    array.push node.value
    preorder(node.left, array)
    preorder(node.right, array)

    return array unless block_given?

    array.map { |value| block.call value }
  end

  def inorder(node = root, array = [], &block)
    return if node.nil?

    inorder(node.left, array)
    array.push node.value
    inorder(node.right, array)

    return array unless block_given?

    array.map { |value| block.call value }
  end

  def postorder(node = root, array = [], &block)
    return if node.nil?

    postorder(node.left, array)
    postorder(node.right, array)
    array.push node.value

    return array unless block_given?

    array.map { |value| block.call value }
  end

  def height(base = 1, node = root)
    return base if node.left.nil? && node.right.nil?

    base += 1
    left_height = base
    right_height = base
    left_height = height(base, node.left) unless node.left.nil?
    right_height = height(base, node.right) unless node.right.nil?

    left_height >= right_height ? left_height : right_height
  end

  def depth(value, node = root, base = 1)
    return nil if node.nil?
    return base if node.value == value

    base += 1

    if value > node.value
      depth(value, node.right, base)
    else
      depth(value, node.left, base)
    end
  end

  def balance?
    (height(1, root.left) - height(1, root.right)).abs <= 1
  end

  def rebalance
    return if balance?

    dif = height(1, root.left) - height(1, root.right)
    while height(1, root.left) != height(1, root.right)
      if dif > 0
        random = rand(root.value + 1..1000)
        insert(random)
      else
        random = rand(-1000..root.value - 1)
        insert(random)
      end
    end
  end

  private

  def tree(sorted)
    return Node.new(sorted[0]) if sorted.size == 1

    node = Node.new(sorted[sorted.size / 2])
    node.left = tree(sorted[0..sorted.size / 2 - 1]) if left?(node.value, sorted)
    node.right = tree(sorted[sorted.size / 2 + 1, sorted.size - 1]) if right?(node.value, sorted)
    node
  end

  def left?(value, array)
    array.any? { |item| item < value }
  end

  def right?(value, array)
    array.any? { |item| item > value }
  end
end
