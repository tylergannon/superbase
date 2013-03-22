module SimpleDatabase
  class Node
    attr_accessor :depth, :children, :value, :key_part, :parent
    
    def initialize(depth, key_part, parent)
      self.depth = depth
      self.key_part = key_part
      self.parent = parent
      self.children  = []
    end
    
    def []=(key, val)
      set key, val
    end
    
    def [](key)
      get key
    end

    def find_node(key)
      if depth == key.size
        return self
      else
        key_part = key[depth]
        for i in 0..children.size-1
          child = children[i]
          if child.key_part == key_part
            return child.find_node(key)
          end
        end
      end
      return nil
    end
    
    def delete(node)
      if children.size==1 && value.nil? && !parent.nil?
        parent.delete(self)
      else
        for i in 0..children.size-1
          if children[i].key_part == node.key_part
            children.delete_at(i)
            break
          end
        end
      end
    end
    
    def set(key, value)
      if depth == key.size
        self.value = value
      else
        #  Find or create a new node at this level
        key_part = key[depth]
        insert_at = nil
        containing_node = nil
        
        for i in 0..children.size-1
          child = children[i]
          
          comparison = key_part <=> child.key_part
          
          case comparison
          when -1
            insert_at = i
            break
          when 0
            containing_node = child
            break
          end
        end
        
        unless containing_node
          containing_node = Node.new(depth+1, key_part, self)
          if insert_at
            children.insert insert_at, containing_node
          else
            children.push containing_node
          end
        end
        
        containing_node.set key, value
      end
    end
  end
  
  class Hax0rSearchTree < Node
    def initialize
      super 0, nil, nil
    end
    
    def unset(key)
      node = find_node(key)
      return unless node
      node.value = nil

      if node.children.empty? && node.value.nil?
        node.parent.delete(node)
      end
    end
    
    def get(key)
      node = find_node(key)
      node ? node.value : nil
    end
  end
end
