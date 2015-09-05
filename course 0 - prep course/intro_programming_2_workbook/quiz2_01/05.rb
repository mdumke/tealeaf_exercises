# You are given the following class that has been implemented:

class KrispyKreme
  attr_reader :filling_type, :glazing

  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    fill = filling_type ? filling_type.to_s : 'Plain'
    glaze = glazing ? " with #{glazing}" : ''

    fill + glaze
  end
end

# And the following specification of expected behavior:

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1
puts "Plain"

puts donut2
puts "Vanilla"

puts donut3
puts "Plain with sugar"

puts donut4
puts "Plain with chocolate sprinkles"

puts donut5
puts "Custard with icing"

# Write additional code for KrispyKreme such that the puts statements will work as specified above.
