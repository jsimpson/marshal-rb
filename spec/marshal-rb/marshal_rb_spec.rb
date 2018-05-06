require "spec_helper"

RSpec.describe MarshalRb do
  it "has a version number" do
    expect(MarshalRb::VERSION).not_to be nil
  end

  describe '.load' do
    FIXTURES.each do |fixture_name, fixture_value|
      it "loads marshalled #{fixture_name}" do
        result = MarshalRb.load(Marshal.dump(fixture_value))
        expect(result).to eq(fixture_value)
      end
    end

    it 'loads marshalled extended object' do
      object = [].extend(MyModule)
      result = MarshalRb.load(Marshal.dump(object))
      expect(result).to be_a(MyModule)
    end
  end

  describe '.dump' do
    FIXTURES.each do |fixture_name, fixture_value|
      it "writes marshalled #{fixture_name}" do
        marshalled = MarshalRb.dump(fixture_value)
        loaded = Marshal.load(marshalled)
        expect(loaded).to eq(fixture_value)
      end
    end
  end
end
