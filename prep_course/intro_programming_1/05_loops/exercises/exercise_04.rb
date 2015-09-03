# exercise 4: counting down to zero
def count_down_from(counter)
  # base cases
  if counter < 0
    return
  elsif counter == 0
    puts "-- liftoff -- (BOOM!)"

  # recursive step
  else
    puts counter

    sleep 1

    count_down_from(counter - 1)
  end
end

count_down_from 10
