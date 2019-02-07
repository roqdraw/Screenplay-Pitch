options = {
    adapter: 'postgresql',
    database: 'screenplays'
}
  
ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)