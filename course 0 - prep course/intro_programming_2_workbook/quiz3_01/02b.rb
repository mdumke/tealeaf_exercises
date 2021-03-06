module RangeInterface
  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  include RangeInterface

  attr_accessor :speed, :heading

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    @fuel_capacity = liters_of_fuel_capacity
    @fuel_efficiency = km_traveled_per_liter
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures along with
    super([20,20], 80, 8.0)
  end
end

class Catamaran
  include RangeInterface

  attr_accessor :propeller_count, :hull_count, :speed, :heading

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    @hull_count = num_hulls
    @propeller_count = num_propellers
    @fuel_capacity = liters_of_fuel_capacity
    @fuel_efficiency = km_traveled_per_liter
  end
end


auto = Auto.new
p auto.range

bike = Motorcycle.new
p bike.range

cat = Catamaran.new(12, 1, 80, 8.0)
p cat.range
