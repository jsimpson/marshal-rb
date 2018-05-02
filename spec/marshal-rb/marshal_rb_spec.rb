require "spec_helper"

RSpec.describe MarshalRb do
  it "has a version number" do
    expect(MarshalRb::VERSION).not_to be nil
  end

  describe ".load" do
    FIXTURES.each do |name, value|
      it "loads a marshalled #{name}" do
        result = MarshalRb.load(Marshal.dump(value))
        expect(result).to eql(value)
      end
    end
  end
end
