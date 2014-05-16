require 'restclient'
require 'dotenv'
require 'json'

def main
  log "Begin trello board caching run"
  username, developer_public_key, member_token = load_credentials
  log "Credentials loaded from env"
  fetch_url = boards_url(username, developer_public_key, member_token)
  log "Fetching with URL [#{fetch_url}]"
  boards = fetch_trello_boards(fetch_url)
  log "Fetched [#{boards.count}] urls"
  boards_data = simplified_boards_data(open_baords(boards))
  write_boards_data_cache_file(boards_data)
  puts "Boards cached successfully."
end

def write_boards_data_cache_file(boards_data)
  open('boards.json', 'w') {|f| f.write(boards_data.to_json) }
end

def fetch_trello_boards(url)
  resp = RestClient.get(url)
  boards = JSON.parse(resp.body.force_encoding('UTF-8'))
rescue RestClient::Unauthorized
  auth_msg = "Unauthorized error. Unable to fetch from API. Exiting"
  log auth_msg
  puts auth_msg
  exit 1
end

def boards_url(username, developer_public_key, member_token)
  api_base_url = 'https://api.trello.com/1/'
  url = "#{api_base_url}members/#{username}/boards?key=#{developer_public_key}&token=#{member_token}"
end

def open_baords(boards)
  boards.select {|board| !board['closed'] }
end

def simplified_boards_data(boards)
  boards.map { |board| board.slice('id', 'name', 'desc', 'url') }
end

def load_credentials
  home_directory = File.expand_path('~/')
  Dir.chdir(home_directory) { Dotenv.load }
  username = ENV['TRELLO_USERNAME']
  developer_public_key = ENV['TRELLO_DEVELOPER_KEY']
  token = ENV['TRELLO_TOKEN']
  credentials = [username, developer_public_key, token]
  unless credentials.all?
    credentials_missing_msg = "Credentials not found. Exiting.\n[expected in ~/.env]. See README"
    log credentials_missing_msg
    puts credentials_missing_msg
    exit 1
  end
  credentials
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

class Hash
  def slice(*keys)
    keys = keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
    hash = self.class.new
    keys.each { |k| hash[k] = self[k] if has_key?(k) }
    hash
  end
end

main
