require 'helper'

include SimpleDatabase

describe SimpleDatabase::Database do
  before do
    @database = SimpleDatabase::Database.new
  end
  
  it "should return null for nonexistent values" do
    @database.get("nonexistent").must_equal nil
  end
  
  it "should store values" do
    @database.set "first_key", 1
    @database.get("first_key").must_equal 1
  end
  
  it "should be able to unset values" do
    @database.set "first_key", 1
    @database.unset "first_key"
    @database.get("first_key").must_equal nil
  end
  
  describe "#unset" do
    describe "handling numequalto" do
      before do
        @database.set 'a', "999"
      end
      it "should reset numequal to zero if last one" do
        @database.unset 'a'
        @database.numequalto('999').must_equal 0
      end
      it "should decrement appropriately" do
        @database.set 'b', '999'
        @database.numequalto('999').must_equal 2
        @database.unset 'a'
        @database.numequalto('999').must_equal 1
      end
    end
  end
  
  describe "#numequalto" do
    it "should be zero" do
      @database.numequalto(2).must_equal 0
    end
    
    describe "when set once" do
      before do
        @database.set "first_key", 1
      end
      
      it "should return one" do
        @database.numequalto(1).must_equal 1
      end
      
      describe "when another var of same value is added" do
        before do
          @database.set "another_key", 1
        end
        it "should be two" do
          @database.numequalto(1).must_equal 2
        end
        
        it "should not count ones that have been reset" do
          @database.set "first_key", 2
          @database.numequalto(1).must_equal 1
        end
        
        it "should not count other keys with a different value" do
          @database.set "different_value", 9
          @database.numequalto(1).must_equal 2
        end
        
        it "should not count values that have been unset" do
          @database.unset "another_key"
          @database.numequalto(1).must_equal 1
        end
      end
    end
  end
  
  describe "command" do
    it "should parse and execute set commands" do
      @database.command "SET a 123"
      @database.get('a').must_equal '123'
    end
    
    it "should parse and execute get commands" do
      @database.set('a', '123')
      @database.command("GET a").must_equal '123'
    end
  end
  
  describe "#begin_transaction" do
    before do
      @open_transactions = @database.send :open_transactions
    end
    it "should start off with no transactions" do
      @open_transactions.must_be_empty
    end
    
    it "should create a transaction object" do
      @database.begin_transaction
      @open_transactions[0].must_be_kind_of Transaction
    end
    
    describe "recording value counts" do
      describe "when the value has been set within the transaction" do
        before do
          @database.begin_transaction
          @database.set 'a', '123'
        end
        it "should record the new value" do
          @database.numequalto('123').must_equal(1)
        end
        
        it "should remove the value if unset" do
          @database.unset('a')
          @database.numequalto('123').must_equal(0)
        end
      end
      
      describe "when the value was previously set" do
        before do
          @database.set 'prior', '123'
          @database.begin_transaction
          @database.set 'a', '123'
        end
        it "should record the new value" do
          @database.numequalto('123').must_equal(2)
        end
      end
    end
    
    describe "within transaction" do
      before do
        @database.command "set a initial_value"
        @database.begin_transaction
        @transaction = @open_transactions.first
      end
      
      it "should report the correct value" do
        @database.command "set a new_value"
        @database.command('get a').must_equal 'new_value'
      end
            
      it "should push the command into the transaction's stack" do
        @database.command "set a new_value"
      end
      
      it "should report zero for values that were unset in the transaction" do
        @database.unset 'a'
        @database.numequalto('initial_value').must_equal 0
      end
      
      it "should report one for values set in the transaction" do
        @database.command "set a new_value"
        @database.numequalto('new_value').must_equal 1
      end
    end
  end
end
