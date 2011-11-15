require 'nokogiri'
require 'rubygems'
require 'rest_client'
require 'sqlite3'


db = SQLite3::Database.new("test.db")

class ThreadPosters
  def initialize(url, db)
	@url = url
	@db = db
  end
  
  def create_table
	@db.transaction 
	  @db.execute("create table posters (id INTEGER PRIMARY KEY, name TEXT);") 
	
	@db.commit
  end
  
  def save_posters
    doc = Nokogiri::HTML(RestClient.get(@url))
	names = doc.css('div[class = "username_container"] strong')
	@db.transaction
	  names.each do |name|
		input = name.text
        @db.execute("insert into posters (name) values (?)", input)
	  end
	@db.commit
  end
  
  attr_reader :url, :db
  attr_writer :url, :db
end
 
 
def test(database)
  tp = ThreadPosters.new("http://forum.bodybuilding.com/showthread.php?t=139556973", database)
  tp.create_table
  tp.save_posters
end
  
test(db)