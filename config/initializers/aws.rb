require 'aws-sdk-s3'
require 'pender_store'

Aws.config.update(
  endpoint: ENV['s3_endpoint'],
  access_key_id: ENV['access_key'],
  secret_access_key: ENV['secret_key'],
  force_path_style: true,
  region: ENV['bucket_region']
)

resource = Aws::S3::Resource.new
[Pender::Store.bucket_name, Pender::Store.video_bucket_name].each do |name|
  bucket = resource.bucket(name)
  unless bucket.exists?
    bucket.create
  end
end
