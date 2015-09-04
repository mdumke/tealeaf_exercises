# break up the following string and put it back together with the words in reverse order:

sentence = "Humpty Dumpty sat on a wall."

p sentence.split(/\W/).reverse.join(' ') + '.'
