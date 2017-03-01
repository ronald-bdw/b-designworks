module Users
  class AwsUploader
    include Interactor

    delegate :file_path, to: :context

    def call
      update_config

      resource_obj.upload_file(file_path, acl: "public-read")
      context.file = resource_obj.public_url
    end

    private

    def resource
      Aws::S3::Resource.new(region: ENV["S3_REGION"])
    end

    def resource_obj
      @obj ||= resource.bucket(ENV["S3_BUCKET"]).object("export_#{Time.current}.xls")
    end

    def update_config
      Aws.config.update(
        credentials: Aws::Credentials.new(ENV["S3_ACCESS_KEY"], ENV["S3_SECRET_KEY"])
      )
    end
  end
end
