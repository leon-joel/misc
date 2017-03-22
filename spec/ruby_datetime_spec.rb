require 'rspec'         # for non-Rails
#require 'rails_helper'  # for Rails

require 'date'

describe 'ruby datetime parse' do
  let(:date1) { "2017-03-12" }
  let(:datetime1) { "2017-02-27T14:30:00" }

  let(:invalid_date1) { "2017-00-12" }

  describe "parse" do
    it 'Date.parse' do
      expect(Date.parse(date1)).to eq Date.new(2017, 3, 12)
      expect(Date.parse(datetime1)).to eq Date.new(2017, 2, 27)
      expect { Date.parse(invalid_date1) }.to raise_error ArgumentError
    end

    it 'DateTime.parse datetime' do
      expect(DateTime.parse(date1)).to eq DateTime.new(2017, 3, 12, 0, 0, 0)
      expect(DateTime.parse(datetime1)).to eq DateTime.new(2017, 2, 27, 14, 30, 0)
    end
  end

  describe "regex datetime" do
    let (:reg_date) { /\A\d{4}-\d{2}-\d{2}\z/ }
    let (:reg_datetime) { /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\z/ }

    it 'date' do
      expect(reg_date =~ date1).to eq 0
      expect(reg_datetime =~ date1).to be_nil
    end

    it "datetime" do
      expect(reg_date =~ datetime1).to be_nil
      expect(reg_datetime =~ datetime1).to eq 0
    end
  end
end
