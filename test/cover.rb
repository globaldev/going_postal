require "coverage" # >= ruby 1.9 only

testing = Dir[File.expand_path("../../lib/**/*.rb", __FILE__)]

at_exit do
  results = Coverage.result.select {|key, value| testing.include?(key)}
  
  all = results.map(&:last).flatten.compact
  print "\n#{all.reject(&:zero?).size}/#{all.size} executable lines covered\n\n"
  
  results.each do |key, value|
    next unless value.include?(0)
    lines = File.readlines(key).zip(value).each_with_index.map do |(line,val),i|
      "%-2s%3i %5s %s" % [(">" if val == 0), (i + 1), val, line]
    end
    print "#{key}\n line calls code\n\n#{lines.join}\n\n"
  end
end

Coverage.start
require_relative "going_postal_test"
