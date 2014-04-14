class ABC
  attr_accessor :instancelevel
  @@classlevel = 100 # this variable is defined in ABC and is shared by reference to instances & children
  def self.classlevel
    @@classlevel
  end
end

puts "ABC.classlevel:#{ABC.classlevel}\n\n"

class DEF < ABC
  @@classlevel = 50 # this now sets all classlevel vars to 50 even ABC.
  @instancelevel = 100 # this is now an instance variable
end

puts "DEF.class_variables:#{DEF.class_variables}"
puts "DEF.instance_variables:#{DEF.instance_variables}\n\n"

puts "DEF.classlevel:#{DEF.classlevel}"
puts "ABC.classlevel:#{ABC.classlevel}\n\n"

class GHI < DEF
  public
  attr_accessor :variable, :instancelevel
  @instancelevel = 50
  variable = 100
  def variable
    return @variable
  end
  def instancelevel
    return @instancelevel
  end
end

p 'DEF.instancelevel:#{DEF.instancelevel} => undefined'
p 'GHI.instancelevel:#{GHI.instancelevel} => undefined'

jkl = GHI.new

puts "jkl.instancelevel:#{jkl.instancelevel}"
puts "jkl.variable:#{jkl.variable}"