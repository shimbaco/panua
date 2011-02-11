Mongoid.configure do |config|
    config.from_hash({'uri' => ENV['MONGOHQ_URL']})
end