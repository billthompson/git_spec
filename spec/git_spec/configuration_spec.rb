require_relative '../spec_helper'
require 'yaml'

RSpec.describe GitSpec::Configuration do
  subject(:config) { described_class }

  let(:git_spec_path) { ::File.join(Dir.getwd, 'git_spec.yml') }
  let(:git_spec_fixture_path) { File.join(Dir.getwd, 'spec', 'fixtures', 'files', 'git_spec.yml') }
  let(:git_spec_unsafe_fixture_path) { File.join(Dir.getwd, 'spec', 'fixtures', 'files', 'unsafe_git_spec.yml') }

  before do
    allow(File).to receive(:exists?).with(git_spec_path).and_return(true)
  end

  describe "#initialize" do
    it "uses default values" do
      config = subject.new

      expect(config.src_root).to eq "lib/"
      expect(config.log_level).to eq ::Logger::INFO
    end

    context "when a git_spec.yml is provided" do
      let!(:config_fixture) { YAML.load_file(git_spec_fixture_path) }

      before do
        allow(YAML).to receive(:load_file).with(git_spec_path).and_return(config_fixture)
        allow(File).to receive(:exists?).with(git_spec_path).and_return(true)
      end

      it "overrides the default config" do
        config = subject.new
        expect(config.src_root).to eq "app/"
      end

      context "and the git_spec.yml declares unknown/unsafe attributes" do
        let!(:config_fixture) { YAML.load_file(git_spec_unsafe_fixture_path) }

        it "doesn't try to set the unknown attribute" do
          expect {
            subject.new
          }.not_to raise_error
        end

        it "overrides the default config with the valid options" do
          config = subject.new
          expect(config.src_root).to eq "app/"
        end
      end
    end
  end
end
