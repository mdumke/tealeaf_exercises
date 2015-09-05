# Alyssa has been assigned a task of modifying a class that was initially created to keep track of secret information. The new requirement calls for adding logging, when clients of the class attempt to access the secret data. Here is the class in its current form:

# class SecretFile
#   attr_reader :data

#   def initialize(secret_data)
#     @data = secret_data
#   end
# end

# She needs to modify it so that any access to data must result in a log entry being generated. That is, any call to the class which will result in data being returned must first call a logging class. The logging class has been supplied to Alyssa and looks like the following

class SecurityLogger
  def create_log_entry
    puts "logging..."
  end
end

# Hint: assume that you can modify the initialize method in SecretFile to have an instance of SecurityLogger be passed in as an additional argument.

class SecretFile
  def initialize(secret_data, logger)
    @data = secret_data
    @logger = logger
  end

  def get_secret_data
    @logger.create_log_entry
    @data
  end
end

file = SecretFile.new("password: 1234love", SecurityLogger.new)
puts file.get_secret_data
