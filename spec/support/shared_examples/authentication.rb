shared_examples "a method that requires an authentication" do |model_name, action|
  example_request "authorization error when #{model_name} #{action}" do
    expect(response_status).to eq 401
  end
end
