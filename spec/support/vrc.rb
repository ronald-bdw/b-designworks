require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "vcr_cassettes"
  c.hook_into :faraday
  c.default_cassette_options = { record: :new_episodes }
end

RSpec.configure do |config|
  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}
    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description]
                    .split(/\s+/, 2).join("/")
                    .underscore.tr("/\./", "/")
                    .gsub(%r{[^\w\/]+}, "_")
                    .gsub(%r{\/$}, "")

      VCR.use_cassette(name, options, &example)
    end
  end
end
