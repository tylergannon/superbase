$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simple_database'

database = SimpleDatabase::Database.new
while line = gets != nil
  line.split("\n").map(&:strip).each do |command|
    output = database.command(command)
    puts output unless output.nil?
  end
end
