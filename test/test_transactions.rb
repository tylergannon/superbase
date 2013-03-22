require 'helper'

describe "Database Transactions" do
  before do
    @database = SimpleDatabase::Database.new
    @database.command 'set a initial_value'
    @database.command 'begin'
    @database.command 'set a new_value'
  end
  
  describe "after committing transaction" do
    it "should be able to set and report values" do
      @database.command 'commit'
      @database.command('get a').must_equal 'new_value'
    end

    it "should be able to unsetvalues" do
      @database.command('unset a')
      @database.command 'commit'
      @database.command('get a').must_equal 'NULL'
    end
  end
  
  describe "after rolling back transaction" do
    it "should return the value that was set prior to beginning transaction" do
      @database.command "rollback"
      @database.command("get a").must_equal 'initial_value'
    end
  end
end
