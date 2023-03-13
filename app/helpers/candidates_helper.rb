module CandidatesHelper
    require 'net/http'
    require 'json'
    require 'dotenv'

    Dotenv.load

    TEAMTAILOR_API_KEY = ENV["TEAMTAILOR_API_KEY"]
    TEAMTAILOR_X_API_VERSION = ENV["TEAMTAILOR_X_API_VERSION"]

    def make_teamtailor_api_request(uri)
        req = Net::HTTP::Get.new(uri)
        req["Authorization"] = "Token token=#{TEAMTAILOR_API_KEY}"
        req["X-Api-Version"] = TEAMTAILOR_X_API_VERSION
    
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(req)
        end
    
        JSON.parse(res.body)
    end

    def fetch_all_candidates(url, candidates = [])
        uri = URI(url)
        candidates_info_response = make_teamtailor_api_request(uri)
    
        next_page = candidates_info_response&.dig("links", "next")
        candidates.concat(candidates_info_response&.dig("data") || []) 

        if next_page
            fetch_all_candidates(next_page, candidates)
        else
            candidates
        end
    end
            
end
