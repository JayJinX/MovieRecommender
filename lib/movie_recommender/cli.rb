require_relative "../../config/environment"

class MovieRecommender::CLI
  attr_accessor :scraper
  MAX_ITEMS = 10

  @@location = []

  def initialize
    @page = 0

  end

  def start 
    puts "Hi! Welcome to MovieRecommender"
    puts "Do you want to want to list movies currently in theaters near to your location?"
    puts "**Input [Y] to continue or input [N] to exit**"

    input = gets.strip

    if input.downcase == "y"
      postalcode_prompt
    elsif input.downcase == "n"
      exit
    else
      puts "Invaild input!"
      start
    end
  end

  def postalcode_prompt
    puts "Please enter the postal code of your location"
    input = gets.strip
    @@location << input
    location_prompt
  end

  def location_prompt
    puts "Please enter your location from the following list"
    puts "AR, AU, CA, CL, DE, ES, FR, IT, MX, NZ, PT, UK, US"
    input = gets.strip
    @@location << input
    list_movies
  end

  def list_movies
    scraper = MovieRecommender::Scraper.new
    scraper.scrape_movies
    MovieRecommender::Movie.all.slice(@page, MAX_ITEMS).each.with_index(1) do |movie, index|
      #slice(0,10); slice(10, 10); silce(20, 10)... @page = 0 each page @page increment 10
      puts "#{index}. #{movie.title}"
    end
    prompt_user
  end
  
  

  def prompt_user 
    puts "*************************************"
    puts "Input n turn to next page of movie list"
    puts "Input p turn to last page"
    puts "Enter the number of the movie you want to check the detail."
    puts "Input [exit] to quit."
    puts "*************************************"

    input = ""

    while input.downcase != "exit"
      input = gets.strip
      actual_input = input.to_i-1

      if input.to_i != 0 && input.to_i <= MovieRecommender::Movie.all.size
        url = MovieRecommender::Movie.all[actual_input].url
        title = MovieRecommender::Movie.all[actual_input].title
        scraper = MovieRecommender::Scraper.new
        scraper.scrape_details(url)
        score = scraper.score
        description = scraper.description
        puts "*******#{title} |IMDB:#{score}|*******"
        puts "***************SUMMARY***************"
        puts description
        puts "*************************************"
        puts "Enter the number of the movie you want to check the detail."
        puts "Input [exit] to quit."
        puts "*************************************"
      elsif input.downcase == "n"
        #41 total the last page will be 41 @page = 40 
        if @page >= 0 && @page + 10 < MovieRecommender::Movie.all.size
          @page = @page + 10
          MovieRecommender::Movie.all.slice(@page, MAX_ITEMS).each.with_index(@page + 1) do |movie, index|
            #slice(0,10); slice(10, 10); silce(20, 10)... @page = 0 each page @page increment 10
            puts "#{index}. #{movie.title}"
          end
        elsif @page +10 > MovieRecommender::Movie.all.size && @page < MovieRecommender::Movie.all.size
          MovieRecommender::Movie.all.slice(@page, MovieRecommender::Movie.all.size - @page).each.with_index(@page + 1) do |movie, index|
            #slice(0,10); slice(10, 10); silce(20, 10)... @page = 0 each page @page increment 10
            puts "#{index}. #{movie.title}"
          end
        else
          puts "This is the end of the page"
          MovieRecommender::Movie.all.slice(@page, MovieRecommender::Movie.all.size - @page).each.with_index(@page + 1) do |movie, index|
            #slice(0,10); slice(10, 10); silce(20, 10)... @page = 0 each page @page increment 10
            puts "#{index}. #{movie.title}"
          end
        end
      
      elsif input.downcase == "p"
        if @page >=0
          @page = @page -10
          MovieRecommender::Movie.all.slice(@page, MAX_ITEMS).each.with_index(@page + 1) do |movie, index|
            #slice(0,10); slice(10, 10); silce(20, 10)... @page = 0 each page @page increment 10
            puts "#{index}. #{movie.title}"
          end
        else
          @page = 0
          MovieRecommender::Movie.all.slice(@page, MAX_ITEMS).each.with_index(@page + 1) do |movie, index|
            #slice(0,10); slice(10, 10); silce(20, 10)... @page = 0 each page @page increment 10
            puts "#{index}. #{movie.title}"
          end
          puts "This is the very first page."
        end
          

      elsif input.downcase == "exit"
        puts "See you next time."
        exit
      else
        puts "Invaild input. Please try again."
      end
    end
  end

  def self.all
    @@location
  end

  def self.clear
    @@location.clear
  end

end
