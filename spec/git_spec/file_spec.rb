require 'spec_helper'

describe GitSpec::File do
  let(:filename) { 'lib/services/my_service.rb' }
  subject(:file) { described_class.new(filename) }

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
end
