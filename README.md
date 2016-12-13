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

## License

This project is licensed under the University of Illinois/NCSA Open Source License. For a full copy of this license take a look at the LICENSE file. 

When contributing new files to this project, preappend the following header to the file as a comment: 

```
Copyright © 2016, ACM@UIUC

This file is part of the Groot Project.  
 
The Groot Project is open source software, released under the University of Illinois/NCSA Open Source License. 
You should have received a copy of this license in a file with the distribution.
```
