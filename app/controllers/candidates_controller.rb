class CandidatesController < ApplicationController

  # TODO Write a test for request method and see if record counts match
  require 'csv'
  require 'net/http'
  require 'json'

  include CandidatesHelper
  include CsvHelper

  TEAMTAILOR_API_BASE_URL = "https://api.teamtailor.com/v1"
  PAGE_SIZE = 30

  def index
  end
  
  def generate_candidates_csv
    request_url = "#{TEAMTAILOR_API_BASE_URL}/candidates?include=job-applications&page[size]=#{PAGE_SIZE}"

    all_candidates = fetch_all_candidates(request_url, [])
    csv_data = candidates_to_csv(all_candidates)
    download_csv_file(csv_data)
  end
end
