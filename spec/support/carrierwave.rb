CarrierWave::Uploader::Base.descendants.each do |klass|
  next if klass.anonymous?

  klass.class_eval do
    def cache_dir
      "test/tmp"
    end

    def store_dir
      "test/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end
