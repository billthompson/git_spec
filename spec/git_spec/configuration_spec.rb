require_relative '../spec_helper'
require 'yaml'

RSpec.describe GitSpec::Configuration do
  subject(:config) { described_class }

  let!(:project_root) { Dir.getwd }
  let(:git_spec_path) { ::File.join(Dir.getwd, 'git_spec.yml') }
  let(:custom_git_spec_path) { File.join(Dir.getwd, 'spec', 'fixtures', 'files', 'custom_git_spec.yml') }
  let(:unsafe_git_spec_path) { File.join(Dir.getwd, 'spec', 'fixtures', 'files', 'unsafe_git_spec.yml') }

  let(:default_regexps) { [/^exe\//, /^spec\//, /^vendor\//, /^config\//, /^regression_tests\//, /^\./] }

  before do
    # allow(::File).to receive(:join).with(Dir.getwd, 'git_spec.yml').and_call_original
    # allow(File).to receive(:exists?).with(git_spec_path).and_return(true)
  end

  describe "#initialize" do
    it "uses default values" do
      config = subject.new

      matched_regexps = config.excluded_file_patterns.each_with_object([]) do |pattern, matched|
        expect(pattern).to be_kind_of(Regexp)
        matched << pattern
      end
      expect(matched_regexps.map(&:to_s)).to match_array(default_regexps.map(&:to_s))

      expect(config.log_level).to eq ::Logger::INFO
      expect(config.spec_command).to eq 'bundle exec rspec'
      expect(config.src_root).to eq 'lib/'
    end

    context "when a custom git_spec.yml is provided" do
      before do
        allow(::File).to receive(:join).with(project_root, 'git_spec.yml').and_return(custom_git_spec_path)
      end

      it "overrides the default config" do
        config = subject.new

        expect(config.log_level).to eq ::Logger::DEBUG
        expect(config.src_root).to eq "app/"
      end

      context "and the git_spec.yml declares unknown/unsafe attributes" do
        before do
          allow(::File).to receive(:join).and_call_original
          allow(::File).to receive(:join).with(project_root, 'git_spec.yml').and_return(unsafe_git_spec_path)
        end

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
