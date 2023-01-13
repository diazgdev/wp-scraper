require 'nokogiri'
require 'open-uri'
require 'csv'

base_url = "https://team.dudeagency.io/sitea/blog/"

CSV.open("posts.csv", "w") do |csv|
  csv << ["Title", "Featured Image URL", "Post Content", "Date Published", "Author", "Category", "Tags", "Slug"]

  page_url = base_url

  loop do
    doc = Nokogiri::HTML(URI.open(page_url))

    titles = doc.search(".wp-block-post-title")

    titles.each do |title|
      post_url = title.css("a").attr("href").text

      post_doc = Nokogiri::HTML(URI.open(post_url))

      post_content = post_doc.search(".entry-content").text

      featured_image_url = post_doc.search(".wp-post-image").attr("src").text

      date_published = post_doc.search(".wp-block-post-date").text

      author = post_doc.search(".wp-block-post-author__name").text

      category = post_doc.search(".taxonomy-category").text

      tags = post_doc.search(".taxonomy-post_tag").text

      slug = title.text.downcase.gsub(/[^a-z0-9\s]/i, '').gsub(/\s+/, '-')

      csv << [title.text, featured_image_url, post_content, date_published, author, category, tags, slug]
    end

    next_page_link = doc.search('a.wp-block-query-pagination-next')
    break if next_page_link.empty?
    page_url = next_page_link.attr("href").text
  end
end

puts "Data saved to posts.csv"
