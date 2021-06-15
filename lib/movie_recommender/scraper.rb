require "require_all"
class MovieRecommender::Scraper
  attr_accessor :base_url, :html, :document, :description, :score

  def initialize
    location = MovieRecommender::CLI.all[1]
    postal_code = MovieRecommender::CLI.all[0]
    @base_url = "https://www.imdb.com/"
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
    html = open("#{@base_url}/#{url}")
    document = Nokogiri::HTML(html)
    @score = document.css(".AggregateRatingButton__RatingScore-sc-1il8omz-1.fhMjqK").text.strip
    description_row = document.css(".ipc-html-content.ipc-html-content--base").first.text.strip.split(".")
    description_row.pop()
    @description = description_row.join(".")
  end
end
