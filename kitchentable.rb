#!/usr/bin/env ruby

require 'json'
require 'uri'
require 'net/http'
require 'date'

tomorrow = Date.today + 1

def check_availability(date)
  availability_uri = URI("https://www.sevenrooms.com/api-yoa/availability/widget/range?venue=kitchentable&time_slot=19:30&party_size=3&start_date=#{date}&num_days=1")
  availability_response = JSON.parse(Net::HTTP.get(availability_uri))
  date_key = availability_response['data']['availability'].keys[0]
  parsed_availability = availability_response['data']['availability'][date_key][0]["times"]
  parsed_availability.map {|value| puts value['real_datetime_of_slot'] if value['access_persistent_id'] != nil}
end

def get_dates(date)
  dates_uri = URI("https://www.sevenrooms.com/api-yoa/availability/dates?venue=kitchentable&num_days=200&start_date=#{date}")
  dates_response = JSON.parse(Net::HTTP.get(dates_uri))
  dates_response['data']['valid_dates']
end

for date in get_dates(tomorrow) do
  check_availability(date)
end
