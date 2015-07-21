# coding: utf-8

# importing XML-files using Nokogiri
require 'nokogiri'

articles = []

File.open('slashdot.xml', 'r') do |file|
  doc = Nokogiri::XML(file)
  articles = doc.css('item').map do |item|
    {
      title:   item.at_css('title').content,
      link:    item.at_css('link').content,
      content: item.at_css('description').content
    }
  end
end

p articles[0][:title]

