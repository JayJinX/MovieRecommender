require_relative "../../config/environment"

require "require_all"
class MovieRecommender::Scraper
  attr_accessor :base_url, :html, :document, :description, :score

  def initialize
    location = MovieRecommender::CLI.all[1]
    postal_code = MovieRecommender::CLI.all[0]
    @base_url = "https://www.imdb.com"
    @html = open("#{@base_url}/showtimes/location/#{location}/#{postal_code}")
    @document = Nokogiri::HTML(html)
  end

  def scrape_movies
    self.document.css(".lister-item.mode-grid").collect do |movie|
      title = movie.css(".title").text.strip
      url = movie.css(".title").css("a").attr("href").value.split("/").slice(2, 3).join("/")
      MovieRecommender::Movie.new(title: title, url: url)
    end
  end

  def scrape_details(url)
    html = open("#{@base_url}/showtimes/#{url}")
    document = Nokogiri::HTML(html)
    @score = document.css(".rating-rating").text.strip
    
    @description = document.css(".outline").text.strip
  end
end
