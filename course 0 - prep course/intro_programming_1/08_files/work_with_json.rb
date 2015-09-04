# importing a json-file
require('json')

articles = []

File.open('feedzilla.json', 'r') do |file|
  items = JSON.parse(file.read)
  puts items
  articles = items['articles'].map do |article|
    {
        title:   article['title'],
        link:    article['url'],
        summary: article['summary']
    }
  end
end

p articles[0][:title]

