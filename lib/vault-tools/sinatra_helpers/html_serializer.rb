require 'base64'

module Vault
  module SinatraHelpers
    # Public: Methods for including and serializing javascript and css files for HTML
    #
    # Examples
    #
    #   # = js 'foo'
    #   # <%= js 'foo', 'bar', 'foo/bar' %>
    #
    #   # = css 'foo'
    #   # <%= cssjs 'foo', 'bar', 'foo/bar' %>
    module HtmlSerializer

      # Public: create js markup by concatenating all javascript files
      #
      # files - one or many file names assuming settings.public_folder/js/ is the root
      #
      # Examples
      #
      #  # given: settings.public_folder/js/hello.js
      #
      #  js('hello')
      #  # => "
      #  #  <script type='text/javascript'>
      #  #  //<![CDATA[
      #  #    alert("hello, world")
      #  #  //]]>
      #  #  </script>"
      #
      # Returns the HTML String
      def js(*files)
        files.inject('') do |string, filename|
          filename = File.join('/js', filename) + '.js'
          string + %{
            <script type='text/javascript'>
            //<![CDATA[
              #{slurp(filename)}
            //]]>
            </script>
          }
        end
      end

      # Public: create css markup with file references replaced by data-urls
      #
      # files - one or many file names assuming settings.public_folder/css/ is the root
      #
      # Examples
      #
      #   # given: settings.public_folder/css/invoice.css
      #
      #   css('invoice')
      #   # => "
      #   # <style>
      #   #   h1{background:url(data:image/png;base64;DEADBEEF)}
      #   # </style>"
      #
      # Returns the HTML String
      def css(*files)
        files.inject('') do |string, filename|
          filename = File.join('/css', filename) + '.css'
          string + "<style>\n#{inject_data_urls(slurp(filename))}\n</style>"
        end
      end

      private
      def inject_data_urls(css_text)
        css_text.gsub(/url\('\/[^\)]+\)/) do |url|
          filename = url.sub(/^url\(["']*/,'').sub(/["']*\)$/,'')
          data = Base64.encode64(slurp(filename)).gsub(/\n/, '')
          if filename =~ /font/
            "url(data:font/opentype;base64,#{data})"
          else
            type = File.extname(filename)[1..-1]
            "url(data:image/#{type};base64,#{data})"
          end
        end
      end

      def slurp(file)
        File.read(File.join(settings.public_folder, file))
      end
    end
  end
end
