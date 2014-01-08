require 'helper'

class SomeS3Consumer
  include S3
end

class S3Test < Vault::TestCase
  def setup
    set_env 'APP_DEPLOY', 'test'
    @consumer = SomeS3Consumer.new
  end

  # S3 writes should be logged.
  def test_write_logs
    mock(Vault::Log).log(is_a(Hash))
    @consumer.write('fake bucket', 'fake key', 'fake value')
  end

  # S3 reads should be logged.
  def test_read_logs
    mock(Vault::Log).log(is_a(Hash))
    @consumer.read('fake bucket', 'fake key')
  end

  # Should use S3 to write to bucket
  def test_writes_to_s3_bucket
    mock(@consumer).s3.mock!.buckets.
      mock!.[]('fake bucket').
      mock!.objects.
      mock!.[]('fake key').
      mock!.write('fake value')
    @consumer.write('fake bucket', 'fake key', 'fake value')
  end

  # Should use S3 to read from bucket
  def test_reads_from_s3_bucket
      #s3.buckets[bucket].objects[key].read
    mock(@consumer).s3.mock!.buckets.
      mock!.[]('fake bucket').
      mock!.objects.
      mock!.[]('fake key').
      mock!.read
    @consumer.read('fake bucket', 'fake key')
  end
end
