module CsvHelper
    require 'csv'

    def download_csv_file(csv_data)
        send_data csv_data, type: 'text/csv', filename: 'candidates.csv'
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
end