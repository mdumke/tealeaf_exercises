# blocks have to start with the ampersand and must be the last parameters
def make_sandwitch(outer, &inner)
  puts outer
  inner.call
  puts outer
end

['cheese', 'butter'].each do |filling|
  make_sandwitch "bread" do
    puts "  #{filling}"
  end
end

repeat = Proc.new do |text, repetitions|
  repetitions.times do
    puts text
  end
end

repeat.call("blah", 4)

