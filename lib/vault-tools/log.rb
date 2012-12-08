module Vault
  module Log
    extend self

    # Public: logs a counter
    #
    # name - Name of the counter
    #
    # Examples
    #   Log.count('foo')
    #   => "measure=true at=foo"
    #
    # Logs via Scrolls
    def count(name)
      log(measure: true, at: name)
    end

    # Public: logs an HTTP status code
    #
    # status - HTTP status code
    #
    # Examples
    #   Log.count_status(400)
    #   => "measure=true at=web-40"
    #
    # Logs via Scrolls
    def count_status(status)
      if prefix = status.to_s.match(/\d\d/)[0]
        log(measure: true, at: "web-#{prefix}")
      end
    end

    # Public: logs the time of a web request
    #
    # name - a Sinatra-formatted route url
    # t - time (integer seconds or milliseconds)
    #
    # Examples
    #   Log.time(name, t)
    #   => "measure=true at=web-40"
    #
    # Logs via Scrolls
    def time(name, t)
      if name
        name.
          gsub(/\/:\w+/,'').            #remove param names from path
          gsub("/","-").                #remove slash from path
          gsub(/[^A-Za-z0-9\-\_]/, ''). #only keep subset of chars
          slice(1..-1).
          tap {|res| log(measure: true, fn: res, elapsed: t)}
      end
    end

    # Internal: log something
    #
    # Logs via Scrolls
    def log(data, &blk)
      Scrolls.log(data, &blk)
    end
  end
end

