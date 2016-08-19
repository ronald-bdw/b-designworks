CarrierWave.configure do |config|
  if Rails.env.development? || Rails.env.test?
    config.storage :file
  else
    config.storage :fog
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      provider:              "AWS",
      aws_access_key_id:      ENV["S3_ACCESS_KEY"],
      aws_secret_access_key:  ENV["S3_SECRET_KEY"],
      region:                 ENV["S3_REGION"]
    }

    config.fog_directory  = ENV["S3_BUCKET"]
    config.fog_public     = false
    config.fog_attributes = { "Cache-Control" => "max-age=#{365.day.to_i}" }
  end
end
