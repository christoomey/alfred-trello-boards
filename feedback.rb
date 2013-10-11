require 'json'
require 'string_score'
require 'nokogiri'

def main
  lines = open('boards.json', 'r') { |f| f.read }
  text = ARGV[0]
  boards = JSON.parse(lines)
  log "testing text: [#{text}] against [#{boards.count}] boards"
  if text && text != ''
    log "scoring boards as text is present"
    respond(score(boards, text))
  else
    log "responding with full boards list"
    respond(boards)
  end
end

def score(boards, text)
  scored = boards.map do |board|
    scorer = StringScore.new(board['name'])
    [scorer.score(text), board]
  end
  non_zero = scored.reject {|(score, board)| score.zero? }
  sorted = non_zero.sort do |(score, board)|
    score
  end
  sorted.map { |(_, board)| board }
end

def respond(boards)
  builder = Nokogiri::XML::Builder.new do |xml|
    xml.items do
      boards.each do |board|
        xml.item('arg' => board['url']) do
          xml.title_ board['name']
          xml.icon 'icon.png'
          xml.subtitle board['desc']
        end
      end
    end
  end

  puts builder.to_xml
end

def log(msg)
  @file ||= open_logger_file
  @file << msg
  @file << "\n"
  @file.flush
end

def open_logger_file
  File.open('log.txt', 'w')
end

main
