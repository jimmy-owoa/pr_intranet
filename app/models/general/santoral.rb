class General::Santoral < ApplicationRecord
    serialize :names, Array
end

# require 'csv'
# csv_text = File.read('santorales2019.csv')
# names = []
# csv = CSV.parse(csv_text)
# csv.each do |row|
#     names << row
# end
