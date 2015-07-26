# In exercise 12, we manually set the contacts hash values one by one. Now, programmatically loop or iterate over the contacts hash from exercise 12, and populate the associated data from the contact_data array.

# returns the data as a correctly formatted hash
def extract_info(data) 
  schema = [:email, :address, :phone]
  
  result = {}

  schema.each_with_index do |category, index|
    result[category] = data[index]
  end

  result
end

contact_data = [["joe@email.com", "123 Main st.", "555-123-4567"],
                ["sally@email.com", "404 Not Found Dr.", "123-234-3454"]]

contacts = {"Joe Smith" => {}, "Sally Johnson" => {}}

# assumes that the hash and the array have the same ordering of contacts
contacts.keys.each_with_index do |key, index|
  contacts[key] = extract_info(contact_data[index])
end

p contacts




