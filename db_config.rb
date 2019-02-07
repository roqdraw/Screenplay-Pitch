options = {
    adapter: 'postgresql',
    database: 'screenplays'
  }
  
  ActiveRecord::Base.establish_connection(options)