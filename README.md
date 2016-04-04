#Groot Quotes Service

##Model
```ruby

class Quote
    include DataMapper::Resource

    property :id, Serial
    property :text, String, required: true
    property :date, DateTime
    property :sources, PgArray
    property :poster, String, required: true, length: 1...9

end
```

##Installing PostgreSQL
```sh
[package-manager] install postgres

initdb /usr/local/var/postgres
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
ps auxwww | grep postgres
createdb groot_quotes_service
```
##Run Application
```sh
ruby ./app.rb
```

##Migrate DB after model alteration
```sh
rake db:migrate
```
