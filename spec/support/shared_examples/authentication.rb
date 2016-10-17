shared_examples "a method that requires an authentication" do |model_name, action|
  context "without authorization token", document: false do
    before do
      header("X-User-Token", nil)
      header("X-User-Phone-Number", nil)
    end

    example_request "authorization error when #{model_name} #{action}" do
      expect(response_status).to eq 401
    end
  end
end
