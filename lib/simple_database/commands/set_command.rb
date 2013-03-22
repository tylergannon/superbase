module SimpleDatabase
  module Commands
    class SetCommand
      attr_accessor :key, :value, :old_value
      
      def initialize(key, value, old_value)
        self.key = key
        self.value = value
        self.old_value = old_value
      end
      
      def rewind(db)
        if old_value == nil
          db.unset key
        else
          db.set key, old_value
        end
        return nil
      end
    end
  end
end