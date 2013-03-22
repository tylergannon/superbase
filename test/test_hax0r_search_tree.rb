require 'helper'

include SimpleDatabase

describe Hax0rSearchTree do
  before do
    @tree = Hax0rSearchTree.new
  end
  
  it "can use indexers" do
    @tree["nice"] = "bar"
    @tree["nice"].must_equal("bar")
  end
  
  it "should store values" do
    @tree.set 'anchorsteam', 1
  end
  
  it "should get values" do
    @tree.set "nicebaz", "cool"
    @tree.set "whatzit", "ohyeah"
    @tree.get("whatzit").must_equal "ohyeah"
  end
  
  describe "#unset" do
    before do
      @tree.set "nicebaz", "cool"
      @tree.set "whatzit", "ohyeah"
      @tree.set "whatit", "ohyeah"
      @tree.set "whazit", "ohyeah"
    end
    it "should unset the value" do
      @tree.get("whatzit").wont_equal nil
      @tree.unset "whatzit"
      @tree.get("whatzit").must_equal nil
    end
    it "should effectively remove keys" do
      @tree.find_node('wha').children.size.must_equal(2)
      @tree.unset "whatzit"
      @tree.find_node('wha').children.size.must_equal(2)
      @tree.unset "whatit"
      @tree.find_node('wha').children.size.must_equal(1)
      @tree.unset "whazit"
      @tree.find_node('wha').must_be_nil
    end
  end
  
  describe "simple child node composition" do
    before do
      @tree.set 'ab', 1
      @node = @tree.children[0]
    end
    
    it "should have one child" do
      @node.children.size.must_equal(1)
    end
    
    it "should have key_part 'a'" do
      @node.key_part.must_equal 'a'
    end
    
    it "should have depth of 1" do
      @node.depth.must_equal 1
    end
    
    describe "second depth child" do
      before do
        @node = @node.children[0]
      end
      it "should have key_part 'b'" do
        @node.key_part.must_equal 'b'
      end
      it "should have value of 1" do
        @node.value.must_equal 1
      end
    end
    
    describe "ordering of elements" do
      before do
        @tree.set "bartholomew", "cubbins"
        @tree.set "abra", 4
        @tree.set "anchor", 9
        @tree.set "actor", 8
        @node = @tree.children.first
      end
      
      it "should have 'b' first" do
        @node.children[0].key_part.must_equal 'b'
      end
      it "should have 'c' second" do
        @node.children[1].key_part.must_equal 'c'
      end
      it "should have 'n' third" do
        @node.children[2].key_part.must_equal 'n'
      end
    end
  end
end