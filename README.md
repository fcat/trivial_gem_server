# Trivial Gem Server

`trivial_gem_server` is a minimal server for your gems. It aims to be fully compatible with rubygems client.

The server is based on [sinatra](http://www.sinatrarb.com) and has no other runtime dependency.

This is just a toy but it's perfect if you want to get into Rubygems API.

## Installation

Add this line to your application's Gemfile:

    gem 'trivial_gem_server'

And then execute:

    $ bundle

If you want to test without running crazy, I suggest you do `gem install`:

    $ gem install trivial_gem_server

## Usage

Use `rack` to run the server:

    $ rackup

You can also provide a `GEM_DIR` where the server will look for gems:

    $ GEM_DIR=/home/fabien/gems rackup

The `GEM_DIR` should contain both `cache` and `specifications` sub directories, like a normal `GEM_HOME`.

To serve your own user's gems, set `GEM_DIR` to match `GEM_HOME`:

```
$ export GEM_HOME=/home/fabien/gems
$ export GEM_PATH=$GEM_HOME
$ gem install sinatra

$ export GEM_DIR=$GEM_HOME
$ rackup
```

Don't forget to configure your client to connect to your server:

```
$ gem sources -a http://localhost:9292/
```

## Testing

To run the full test suite:

    $ rake test

The integration tests rely on dummy gems I have generated using `script/fake_gems`. These gems are based on real one, so it's easy to figure out the dependency chain. The dummy gems are stored in `test/fixtures/gems` and can be rebuilt using `rake fixtures`.

Note that bundler will dynamically add its bundle to your gem set. As a consequence, the tests will fail if you run them using `bundle exec rake test`.
