require 'json'
require 'rexml/document'

def main
  lines = open('boards.json', 'r') { |f| f.read }
  text = ARGV[0]
  boards = JSON.parse(lines)
  log "testing text: [#{text}] against [#{boards.count}] boards"
  if text && text != ''
    log "scoring boards as text is present"
    respond filter(boards, text)
  else
    log "responding with full boards list"
    respond(boards)
  end
end

def filter(boards, text)
  re = text.split(//).map(&Regexp.method(:escape)).join('.*')
  re = /#{re}/i
  boards.select { |board| board['name'] =~ re }.sort do |a, b|
    left = ((a['name'] =~ /#{text}/i) || 1_000)
    right = ((b['name'] =~ /#{text}/i) || 1_000)
    left <=> right
  end
end

def respond(boards)
  doc = REXML::Document.new
  items = doc.add_element('items')
  boards.each do |board|
    item = items.add_element('item')
    item.add_attribute('arg', board['url'])
    item.add_element('title').add_text(board['name'])
    item.add_element('icon').add_text('icon.png')
    item.add_element('subtitle').add_text(board['desc'])
  end

  puts doc.to_s
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
