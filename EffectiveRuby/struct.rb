# require 'pp'
# require 'logger'
# require 'active_support/core_ext/string'          # for String.first
require 'active_support/core_ext/string/strip'  # for strip_heredoc


puts <<-EOS.strip_heredoc
構造化データの表現にはHashではなくStructを使おう
===========================================================
EOS

require 'csv'

class AnnualWeather
  def initialize(file_name)
    @readings = []

    CSV.foreach(file_name, headers: true) do |row|
      @readings << {
          date: Date.parse(row[2]),
          high: row[3].to_f,
          low:  row[4].to_f,
      }
    end
  end

  def data
    @readings
  end

  def mean
    return 0.0 if @readings.size.zero?

    total = @readings.reduce(0.0) do |sum, reading|
      sum + (reading[:high] + reading[:low]) / 2.0
    end

    total / @readings.size.to_f
  end
end

####################################################################
###
### Main
###
if $0 == __FILE__ then
  aw = AnnualWeather.new("weather.csv")

  p aw.data

  p aw.mean
end


puts <<-EOS.strip_heredoc

structに書き換えた
=========================================================
EOS

class AnnualWeather2
  # Structの定義
  Reading = Struct.new(:date, :high, :low) do
    # 月ごとのmean
    def mean
      (high + low) / 2.0
    end
  end

  def initialize(file_name)
    @readings = []

    CSV.foreach(file_name, headers: true) do |row|
      @readings << Reading.new(
          Date.parse(row[2]),
          row[3].to_f,
          row[4].to_f
      )
    end
  end

  def data
    @readings
  end

  # 全ての月を通したMean
  def mean
    return 0.0 if @readings.size.zero?

    total = @readings.reduce(0.0) do |sum, reading|
      sum + (reading.high + reading.low) / 2.0
    end

    total / @readings.size.to_f
  end
end

if $0 == __FILE__ then
  aw = AnnualWeather2.new("weather.csv")

  p aw.data
  p aw.mean

  aw.data.each { |row| puts "#{row.date}: #{row.mean}" }

  reading = aw.data.first
  p reading.class.ancestors   # -> [AnnualWeather2::Reading, Struct, Enumerable, Object, Kernel, BasicObject]

  p aw.class.ancestors        # -> [AnnualWeather2, Object, Kernel, BasicObject]
end



