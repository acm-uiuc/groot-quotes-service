FILE_PATH = "/scripts/data.csv"
puts "IMPORT LOCATION: #{FILE_PATH}"

CSV.foreach(Dir.pwd + FILE_PATH, headers: true) do |row|
  quote_text = Oga.parse_html(row['quote_text']).children
  quote_source = Oga.parse_html(row['quote_sources']).children
  quote_author = Oga.parse_html(row['quote_posters']).children

  next unless quote_text[0] && quote_source[0] && quote_author[0]

  next unless Quote.first(text: quote_text[0].text).nil?

  Quote.create(
    text: quote_text[0].text,
    source: quote_source[0].text.gsub(",", ""),
    author: quote_author[0].text.gsub(",", "") || quote_source[0].text.gsub(",", ""),
    created_at: row['created_at'] ? Date.strptime(row['created_at'], '%m/%d/%y %k:%M') : DateTime.now
  )
end