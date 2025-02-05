require "sinatra"
require "sinatra/reloader"
require "http"

require "dotenv/load"
pp ENV.fetch("EXCHANGE_RATE_KEY")

get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
  @raw_response = HTTP.get(api_url)
  @raw_string = @raw_response.to_s
  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies")

  erb(:homepage)
end

get ("/:first_symbol")do
  @the_symbol = params.fetch("first_symbol")

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
  @raw_response = HTTP.get(api_url)
  @raw_string = @raw_response.to_s
  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies")

  erb(:step_one)

end

get ("/:first_symbol/:second_symbol")do
  @from = params.fetch("first_symbol")
  @to = params.fetch("second_symbol")

  @url = "https://api.exchangerate.host/convert?from=#{@from}&to=#{@to}&amount=1&access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"

  @raw_response = HTTP.get(@url)
  @raw_string =  @raw_response.to_s
  @parsed_data = JSON.parse(@raw_string)

  @conversion = @parsed_data.fetch("result")

  erb(:step_two)
end
