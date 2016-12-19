require 'spec_helper'

describe GitSpec::File do
  let(:filename) { 'lib/services/my_service.rb' }
  subject(:file) { described_class.new(filename) }

  describe "#initialize" do
    it "has a path" do
      expect(subject.path).to eq filename
    end

    it "has a configuration" do
      expect(subject.configuration).to be_kind_of(GitSpec::Configuration)
    end
  end

  describe "#path" do
    it "is a string" do
      expect(subject.path).to be_kind_of(String)
    end
  end

  describe "#path=" do
    it "can accept a string" do
      subject.path = 'my_path.rb'
      expect(subject.path).to eq 'my_path.rb'
    end

    it "can accept a Pathname" do
      subject.path = Pathname.new('my_path.rb')
      expect(subject.path).to eq 'my_path.rb'
    end
  end

  describe "#spec_path" do
    it "builds the spec path" do
      expect(file.spec_path).to eq 'spec/services/my_service_spec.rb'
    end

    context "when the file is a spec" do
      let(:filename) { 'spec/services/my_service_spec.rb' }

      it "returns itself" do
        expect(file.spec_path).to eq filename
      end
    end
  end

  describe "#allowed_file_type?" do
    context "when the ext is in the list of allowed_file_types" do
      it "is allowed" do
        expect(file.allowed_file_type?).to be_truthy
      end
    end

    context "when the ext is not in the list of allowed_file_types" do
      let(:filename) { 'lib/services/my_service.not-rb' }

      it "is not allowed" do
        expect(file.allowed_file_type?).to be_falsey
      end
    end
  end

  describe "#excluded?" do
    it "is falsey" do
      expect(file.excluded?).to be_falsey
    end

    context "when the file extentions is not an allowed file extension" do
      let(:filename) { 'lib/services/my_service.js' }

      it "is excluded" do
        result, reason = file.excluded?
        expect(result).to be_truthy
        expect(reason).to eq :forbidden_file_type
      end
    end

    context "when the file name matches an excluded file pattern" do
      let(:filename) { 'vendor/my_service.rb' }

      it "is excluded" do
        result, reason = file.excluded?
        expect(result).to be_truthy
        expect(reason).to eq :excluded_file_pattern
      end
    end
  end

  describe "#extname" do
    it "is the path's ext" do
      expect(file.extname).to eq Pathname.new(filename).extname
    end
  end
end
