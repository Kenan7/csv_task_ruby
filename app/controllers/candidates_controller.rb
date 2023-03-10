class CandidatesController < ApplicationController
# TODO Write a test for request method and see if record counts match
  require 'csv'
  require 'net/http'
  require 'json'
  require 'dotenv'

  Dotenv.load
  
  TEAMTAILOR_API_BASE_URL = "https://api.teamtailor.com/v1"
  TEAMTAILOR_API_KEY = ENV["TEAMTAILOR_API_KEY"]
  PAGE_SIZE = 30
  
  def index
  end

  def make_teamtailor_api_request(uri)
    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "Token token=#{TEAMTAILOR_API_KEY}"
    req["X-Api-Version"] = ENV[TEAMTAILOR_X_API_VERSION]

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    JSON.parse(res.body)
  end
  
  def fetch_candidates(url = nil)
    uri = url || URI("#{TEAMTAILOR_API_BASE_URL}/candidates?page[size]=#{PAGE_SIZE}&include=job-applications")
    uri = URI(url) if url
    make_teamtailor_api_request(uri)
  end
  
  def candidates_to_csv(candidates)
    CSV.generate do |csv|
      csv << [
        "candidate_id",
        "first_name",
        "last_name",
        "email",
        "job_application_id",
        "job_application_created_at"
    ]
      candidates.each do |candidate|
        candidate_id = candidate&.[]("id")
        first_name = candidate&.dig("attributes", "first-name")
        last_name = candidate&.dig("attributes", "last-name")
        email = candidate&.dig("attributes", "email")

        job_application_created_at = DateTime.parse(
            candidate&.dig("attributes", "created-at")
        ).strftime("%d %B %Y %H:%M:%S") # 05 April 2000 12:00:00

        job_applications = candidate&.dig("relationships", "job-applications", "data")

        job_applications.each do |job_application|
            job_application_id = job_application&.[]("id")
            csv << [
                candidate_id,
                first_name,
                last_name,
                email,
                job_application_id,
                job_application_created_at
            ]
        end
    end
    end
  end
  
  def download_csv_file(csv_data)
    send_data csv_data, type: 'text/csv', filename: 'candidates.csv'
  end
  
  def generate_csv
    all_candidates = []
    candidate_response = fetch_candidates
    all_candidates.concat(candidate_response&.[]("data"))

    while candidate_response["links"]["next"]
        candidate_response = fetch_candidates(candidate_response&.dig("links", "next"))
        all_candidates.concat(candidate_response&.[]("data"))
    end

    csv_data = candidates_to_csv(all_candidates)
    download_csv_file(csv_data)
  end
end
