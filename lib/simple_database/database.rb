module SimpleDatabase
  class Database
    def initialize
      @open_transactions = []
      @key_map = Hax0rSearchTree.new
      @value_map = Hax0rSearchTree.new
      super()
    end

    def set(key, value)
      old_value = get(key)
      if transaction_open?
        current_transaction.commands << Commands::SetCommand.new(key, value, old_value)
      end
      decrement_count old_value if old_value
      key_map[key] = value
      increment_count value
      return nil
    end

    def get(key)
      return key_map[key] || nil
    end
    
    def unset(key)
      old_value = get(key)
      
      #  Don't unset a nonexistent value
      return if old_value == nil
      
      #  Prepare for a potential rewind
      if transaction_open?
        current_transaction.commands << Commands::UnsetCommand.new(key, old_value)
      end
      
      decrement_count old_value
      key_map.unset(key)
    end
        
    def numequalto(value)
      value_map[value] || 0
    end
        
    def begin_transaction
      open_transactions.unshift Transaction.new
    end
    
    def rollback_transaction
      if open_transactions.empty?
        puts 'INVALID ROLLBACK'
      else
        transaction = open_transactions.pop
        transaction.commands.each do |command|
          command.rewind self
        end
      end
    end
    
    def commit_transaction
      open_transactions.clear
    end
    
    def command(str)
      parts = str.split(' ')
      command_type = parts.shift.downcase
      
      return_value = nil
      
      case command_type
      when 'set'
        set *parts
      when 'unset'
        unset *parts
      when 'numequalto'
        return_val = numequalto *parts
      when 'get'
        return_val = get(parts[0]) || 'NULL'
      when 'begin'
        begin_transaction
      when 'rollback'
        rollback_transaction
      when 'commit'
        commit_transaction
      when 'end'
        Process.exit
      else
        return_val = "not make sense"
      end
      return_val
    end
    
    private
    
    def transaction_open?
      !open_transactions.empty?
    end
    
    def current_transaction
      open_transactions.last
    end
        
    def build_command(str)
      parts = str.split(' ')
      name = parts.shift
      command = SimpleDatabase::Commands.const_get("#{name.capitalize}Command").new *parts
    end
    
    def open_transactions
      @open_transactions
    end

    def key_map
      @key_map
    end
    
    def value_map
      @value_map
    end
    
    def decrement_count(value)
      node = value_map.find_node(value)
      node.value -= 1 unless node.nil? || node.value <= 0
    end
    
    def increment_count(val)
      node = value_map.find_node(val)
      if node
        node.value += 1
      else
        value_map[val] = 1
      end
    end
  end
end