require 'rails_helper'
require_relative '../../app/controllers/candidates_controller.rb'


class CandidatesControllerTest < ActionDispatch::IntegrationTest
  RSpec.describe CandidatesController, type: :controller do
    describe "#generate_candidates_csv" do
      let(:all_candidates) { [{ "id" => "1", "attributes" => { "first-name" => "John", "last-name" => "Doe", "email" => "john.doe@example.com", "created-at" => "2022-02-22T10:10:10Z" }, "relationships" => { "job-applications" => { "data" => [{ "id" => "2" }] } } }] }
      let(:csv_data) { "candidate_id,first_name,last_name,email,job_application_id,job_application_created_at\n1,John,Doe,john.doe@example.com,2,22 February 2022 10:10:10\n" }
  
      before do
        allow(controller).to receive(:fetch_all_candidates).and_return(all_candidates)
        allow(controller).to receive(:download_csv_file)
        get :generate_candidates_csv
      end
  
      it "calls fetch_all_candidates with the correct URL" do
        expect(controller).to have_received(:fetch_all_candidates).with("https://api.teamtailor.com/v1/candidates?include=job-applications&page[size]=30", [])
      end
  
      it "calls candidates_to_csv with the correct arguments" do
        expect(controller).to have_received(:candidates_to_csv).with(all_candidates)
      end
  
      it "calls download_csv_file with the correct arguments" do
        expect(controller).to have_received(:download_csv_file).with(csv_data)
      end
  
      it "responds with a CSV file attachment" do
        expect(response.headers['Content-Type']).to eq 'text/csv'
        expect(response.headers['Content-Disposition']).to include('attachment; filename="candidates.csv"')
      end
    end
  end
end  
