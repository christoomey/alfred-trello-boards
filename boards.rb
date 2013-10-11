require 'restclient'
require 'json'
require 'yaml'

Board = Struct.new(:id, :name, :description, :url) do
  def to_json
    Hash[self.each_pair.to_a].to_json
  end
end

class Hash
  def slice(*keys)
    keys = keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
    hash = self.class.new
    keys.each { |k| hash[k] = self[k] if has_key?(k) }
    hash
  end
end

def main
  trello = authenticated_trello_client
  open('boards.json', 'w') {|f| f.write(trello.to_json) }
end

def authenticated_trello_client
  api_base_url = 'https://api.trello.com/1/'
  username = 'ctoomey'
  developer_public_key = 'c2a20b6b4c6433d26a9878f6a42b8db7'
  member_token = '44267ceee0bf7a08443ceeaefbf1cf5b64b701140af721dbbbd19c03f870608b'
  url = "#{api_base_url}members/#{username}/boards?key=#{developer_public_key}&token=#{member_token}"
  resp = RestClient.get url
  boards = JSON.parse resp
  mine = myboards(open_baords(boards))
end

def open_baords(boards)
  boards.select {|board| !board['closed'] }
end

def myboards(boards)
  # boards.map { |board| Board.new(board['id'], board['name'], board['desc'], board['url']) }
  boards.map { |board| board.slice('id', 'name', 'desc', 'url') }
end

main
