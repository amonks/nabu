nabu
====

![nabu](http://f.cl.ly/items/0f150s0n2z1h3M271m3B/SuperStock_4048-2804.jpg)

arbitrary-form data collector and grapher using sinatra and d3

![screenshot](http://cl.ly/XuB9/screen.png)

## Install

    git clone https://github.com/amonks/nabu.git
    cd nabu
    bundle install
    bundle exec ruby app.rb

run `pd/testdata.pd` to generate some sample data and send it to localhost on `:4567`

## HTTP GET api

### create

    /data/table/add/column:value/column:value/...

### read

    /data/json
    /data/graph

    /data/table/json
    /data/table/graph

    /data/table/column/json
    /data/table/column/graph

### destroy

    /data/flush

    /data/table/flush

    /data/table/column/flush

### dev

    /pry    # repl in server console
