require 'csv'
require 'nokogiri'
require 'open-uri'
require 'yaml'

# DataGenerator Factory scrapes remote URL & processes the data.
#
class DataGenerator
  class << self
    RESOURCE_URL = YAML.load_file('config/urls.yml')

    def table_titles
      @table_titles = []
    end

    def resource_locator
      url = RESOURCE_URL['moh']
    end

    def parse_document
      html = open(resource_locator)
      doc = Nokogiri::HTML(html)

      state_data = doc.css('#state-data')
      upload_timestamp_string = doc.css('.status-update')
      @upload_date_parsed = Date.parse(upload_timestamp_string.children.text).strftime('%m-%d-%Y')
      table = state_data.at('table')

      create_data_attribs(table)

      today_date = Date.today.strftime("%m-%d-%Y")
    end

    def create_csv_file
      csv_file = 'data/states_data_aggregated.csv'

      existing_title = File.readlines(csv_file).map(&:strip).first if File.exists?(csv_file)

      parse_document

      CSV.open("data/#{@upload_date_parsed}_data.csv", "w+") do |csv|
        csv << @titles
        @rows.each do |row|
          csv << row.unshift(@upload_date_parsed)
        end
      end

      CSV.open('data/states_data_aggregated.csv', 'a+') do |csv2|

        titles = @titles
        titles[3] = titles[3].split(' (').first

        unless existing_title&.include?(@titles[0])
          csv2 << @titles
        end

        @rows.each do |row|
          next if row.size < 5
          csv2 << row.unshift(@upload_date_parsed)
        end
      end
    end

    def create_data_attribs(table)
      @titles = []
      @rows = []
      table.search('tr').each do |tr|
        cells = tr.search('th')
        cells2 = tr.search('td')
        each_row = []
        cells.each do |c|
          @titles << c.children.text
        end
        next if cells2.empty?
        cells2.each do |c2|
          each_row << c2.children.text.strip
        end
        @rows << each_row
      end
      # Prepend 'Date' column
      @titles.unshift('Date')
    end
  end
end

DataGenerator.create_csv_file
