require 'nokogiri'
require 'mechanize'
require 'csv'

MAIN_URL = 'http://trend.kerala.gov.in/mnic/la.php?id='
agent = Mechanize.new

(1..140).each do|i|
  page = agent.get("#{MAIN_URL}#{i}")
  processed_page = Nokogiri::HTML(page.body)
  CSV.open('./candiadte_vote.csv', 'a+') do |csv|
    processed_page.css("tr").each do |tr|
      if !(tr.css("td")[2].text =~ /Candidate/) && !(tr.css("td")[2].text =~ /N O T A/)
        csv << [tr.css('td')[2].text,"#{processed_page.css("h2.laname").text.gsub('DECLARED', '').strip}", "#{tr.css("td")[3].text.to_i}"]
      end
    end
  end
end
