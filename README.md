# Groot Quotes Service

## Installing MySQL
```sh
brew install mysql
```

## Migrate DB after model alteration (clears all data)
```
rake db:migrate
```

## Create secrets.yaml and database.yaml

```
cp secrets.yaml.template secrets.yaml
cp database.yaml.template database.yaml
```

## Create databases

You need to login to `mysql`, and create the database names for your development and test environments and fill it in the `database.yaml`. For example,

In `mysql`:
```
CREATE DATABASE groot_recruiter_service
```

## Run Application
```
ruby app.rb
```

## Routes

:: GET ::
/quotes
/quotes/:quote_id
/status

:: POST ::
/quotes
/quotes/:quote_id/vote

:: DELETE ::
/quotes/:id
/quotes/:quote_id/vote

:: PUT ::
/quotes/:id/approve


## License

This project is licensed under the University of Illinois/NCSA Open Source License. For a full copy of this license take a look at the LICENSE file. 

When contributing new files to this project, preappend the following header to the file as a comment: 

```
Copyright © 2016, ACM@UIUC

This file is part of the Groot Project.  
 
The Groot Project is open source software, released under the University of Illinois/NCSA Open Source License. 
You should have received a copy of this license in a file with the distribution.
```
