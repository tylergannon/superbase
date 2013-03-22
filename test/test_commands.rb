require 'helper'
include SimpleDatabase::Commands

describe SimpleDatabase::Commands do
  before do
    @database = SimpleDatabase::Database.new
  end

  describe SetCommand do
    it "should set the value in the database" do
      command = SetCommand.new("a", 12345, 432)
      command.rewind(@database)
      @database.get("a").must_equal 432
      @database.numequalto(432).must_equal 1
    end
  end

  describe UnsetCommand do
    before do
      @database.set "nice", :bar
      command = UnsetCommand.new("nice", 432)
      command.rewind(@database)
    end
    
    it "should rewind the value in the database" do
      @database.get("nice").must_equal 432
    end
    
    it "should rewind the number of corresponding values" do
      @database.numequalto(432).must_equal 1
    end
  end  
end

