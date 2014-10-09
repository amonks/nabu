Nabu
====

arbitrary-form data collector and grapher using sinatra and d3

<img class="img-responsive" src="http://f.cl.ly/items/0f150s0n2z1h3M271m3B/SuperStock_4048-2804.jpg" alt="nabu" />

## Use

Add data using the HTTP GET API.

Add `50.8` to the `room1` column in the `sights` table:

[/data/`sights`/add/`room1`:`50.8`](/data/sounds/add/room1:50.8)

You can add to multiple columns within the same table for a multivariate line graph:

[/data/sounds/add/`left:10`/`right:20`](/data/sounds/add/left:10/right:20)

If one column is called `min` and another `max`, you'll get a bivariate area graph:

[/data/smells/add/`min`:2/`max`:20](/data/smells/add/min:2/max:20)

## Install

    git clone https://github.com/amonks/nabu.git
    cd nabu
    bundle install
    bundle exec ruby app.rb

Nabu expects to find an appropriate postgres url (postgres://localhost/nabu) in an environment variable called `DATABASE_URL`.

After creating a database, visit `/migrate` to get the schema set up.

run `pd/testdata.pd` to generate some sample data and send it to localhost on `:4567`

## HTTP GET API

vars in [brackets]

    /info     # show this page

### create

    /data/[table]/add/[column]:[value]/[column]:[value]/...

### read

    /data/json
    /data/graph

    /data/[table]/json
    /data/[table]/graph

    /data/[table]/[column]/json
    /data/[table]/[column]/graph

### destroy

    /data/flush

    /data/[table]/flush

    /data/[table]/[column]/flush

### dev

    /pry      # repl in server console

    /migrate  # prepare database (run once after install)
