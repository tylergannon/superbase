module SimpleDatabase
  module Commands
    class UnsetCommand < SetCommand
      attr_accessor :key, :old_value
      
      def initialize(key, old_value)
        self.key = key
        self.old_value = old_value
      end
      
      def rewind(db)
        db.set key, old_value
        return nil
      end
    end
  end
end