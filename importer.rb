# frozen_string_literal: true

require 'csv'
require 'net/http'
require 'json'
require 'base64'

wp_url = URI('http://test3.local/wp-json/wp/v2/posts')

username = 'admin'
password = 'admin'

# Encode credentials in base64
credentials = Base64.strict_encode64("#{username}:#{password}")

CSV.foreach('posts.csv', headers: true) do |row|
  post_data = {
    title: row['Title'],
    featured_media: row['Featured Image URL'],
    content: row['Post Content'],
    date: row['Date Published'],
    author: row['Author'],
    categories: row['Category'],
    tags: row['Tags'],
    slug: row['Slug']
  }
  request = Net::HTTP::Post.new(wp_url.request_uri)
  request['Content-Type'] = 'application/json'
  # Add Authorization header
  request['Authorization'] = "Basic #{credentials}"
  request.body = post_data.to_json
  # Send POST request to Wordpress REST API to create new post
  response = http.request(request)
  puts response.code
  puts response.body
end
