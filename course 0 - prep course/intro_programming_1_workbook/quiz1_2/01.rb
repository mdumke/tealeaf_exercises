# see if there is an age present for "Spot"
ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

p ages.has_key? 'Spot'
p ages.member? 'Spot'
p !ages['Spot'].nil?
p ages.include? 'Spot'
p begin ages.fetch('Spot') rescue false end

