require 'rails_helper'
require_relative '../../app/helpers/csv_helper'

RSpec.describe CsvHelper do
  include CsvHelper

  describe "#download_csv_file" do
    let(:csv_data) { "1,John,Doe,john.doe@example.com,2,2022-02-22 10:10:10\n" }

    it "sends csv data with correct type and filename" do
      controller = ActionController::Base.new
      expect(controller).to receive(:send_data).with(
        csv_data,
        type: 'text/csv',
        filename: 'candidates.csv'
      )
      download_csv_file(csv_data)
    end
  end

  describe "#candidates_to_csv" do
    let(:candidates) {[
      {
        "id" => 1,
        "attributes" => {
          "first-name" => "John",
          "last-name" => "Doe",
          "email" => "john.doe@example.com",
          "created-at" => "2022-02-22T10:10:10Z"
        },
        "relationships" => {
          "job-applications" => {
            "data" => [{ "id" => 2 }]
          }
        }
      }
    ]}

    it "returns a valid CSV string" do
      csv_string = candidates_to_csv(candidates)
      csv = CSV.parse(csv_string)

      expect(csv.size).to eq(2) # header + 1 row
      expect(csv[0]).to eq([
        "candidate_id",
        "first_name",
        "last_name",
        "email",
        "job_application_id",
        "job_application_created_at"
      ])
      expect(csv[1]).to eq([
        "1",
        "John",
        "Doe",
        "john.doe@example.com",
        "2",
        "22 February 2022 10:10:10"
      ])
    end
  end
end
