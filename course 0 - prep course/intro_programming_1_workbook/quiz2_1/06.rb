# Alyssa was asked to write an implementation of a rolling buffer. Elements are added to the rolling buffer and if the buffer becomes full, then new elements that are added will displace the oldest elements in the buffer.

# She wrote two implementations saying, "Take your pick. Do you like << or + for modifying the buffer?". Is there a difference between the two, other than what operator she chose to use to add an element to the buffer?

def rolling_buffer1(buffer, max_buffer_size, new_element)
  buffer << new_element
  buffer.shift if buffer.size >= max_buffer_size
  buffer
end

def rolling_buffer2(input_array, max_buffer_size, new_element)
  buffer = input_array + [new_element]
  buffer.shift if buffer.size >= max_buffer_size
  buffer
end

# testing buffer methods
def buffer_test(buffer, &rolling_buffer)
  arr = [1, 2, 2, 3, 3, 3, 4, 4, 5, 6]

  arr.each do |new_element|
    buffer = rolling_buffer.yield(buffer, 4, new_element)
    p buffer
  end
end

buffer = []
buffer_test(buffer) { |buf, max, new_el| rolling_buffer1(buf, max, new_el) }
p "buffer is now: #{buffer}"

puts

buffer = []
buffer_test(buffer) { |buf, max, new_el| rolling_buffer2(buf, max, new_el) }
p "buffer is now: #{buffer}"