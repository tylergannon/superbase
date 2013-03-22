$LOAD_PATH.unshift('/Users/tyler/src/dev/simple_database', 'lib')
require 'simple_database.rb'
include SimpleDatabase
@tree = Hax0rSearchTree.new
@tree.set "nice", 9

# SET a 10
# BEGIN
# NUMEQUALTO 10
# BEGIN
# UNSET a
# NUMEQUALTO 10
# ROLLBACK
# NUMEQUALTO 10
# END
