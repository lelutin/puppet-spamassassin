require 'spec_helper_acceptance'

describe 'spamassassin' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      manifest = <<-EOS
        class { 'spamassassin':
          sa_update       => true,
          service_enabled => true,
        }
      EOS

      apply_manifest(manifest, :catch_failures => true)
      expect(apply_manifest(manifest, :catch_failures => true).exit_code).to be_zero
    end
  end
end