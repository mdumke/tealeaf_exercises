# turn this into a new array that consists of strings containing one word
arr = ['white snow', 'winter wonderland', 'melting ice',
       'slippery sidewalk', 'salted roads', 'white trees']

p arr.map { |str| str.split }.flatten

