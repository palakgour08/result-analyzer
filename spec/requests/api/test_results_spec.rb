require 'rails_helper'

RSpec.describe 'Api::TestResults', type: :request do
  describe 'POST /api/test_results' do
    let(:params) do
      {
        student_name: 'Palak',
        subject: 'Math',
        marks: 88,
        timestamp: Time.current
      }
    end

    it 'creates a test result' do
      expect {
        post '/api/test_results', params: params
      }.to change(TestResult, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.parsed_body).to include('id' => TestResult.last.id)
    end

    it 'stores timestamp as submitted_at' do
      post '/api/test_results', params: params.merge(timestamp: '2026-05-10T14:30:00Z')

      expect(TestResult.last.submitted_at).to eq(Time.zone.parse('2026-05-10T14:30:00Z'))
    end

    it 'rejects invalid payloads' do
      expect {
        post '/api/test_results', params: params.merge(subject: ' ', marks: 101)
      }.not_to change(TestResult, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body.fetch('errors')).to include(
        "Subject can't be blank",
        'Marks must be less than or equal to 100'
      )
    end
  end
end
