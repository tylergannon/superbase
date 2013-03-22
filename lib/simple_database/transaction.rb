module SimpleDatabase
  class Transaction
    attr_accessor :commands
    
    def initialize
      self.commands = []
    end
  end
end