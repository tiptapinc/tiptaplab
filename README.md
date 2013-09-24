# Tiptaplab

The tiptaplab gem will provide easy and painless access to the TipTapLab API.

## Installation

Add this line to your application's Gemfile:

    gem 'tiptaplab'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tiptaplab

## Usage

First, [register your application with the TipTapLab API][register]

Then, create a new `Tiptaplab::Api` instance, specifying your `app_id` and `app_secret`:

    api = Tiptaplab::Api.new(:app_id => YOUR_APP_ID, :app_secret => YOUR_APP_SECRET)

In addition to the required app_id and app_secret, you can specify `:api_environment`. If this is set to 'staging', the gem will use the [TipTapLab staging API][staging]. This is useful while your app is in development, but remember that API data created on staging will not be available once you switch to production mode, and that your App credentials may be different.

You can also make arbitrary calls to the api using the `make_call` method:

    api.make_call(call_path, data, method)

The default `data` is an empty hash and the default method is 'GET', so you can make simple requests with just the call path:

    api.make_call('traits')
    => [{"title"=>"Susceptability", "key"=>"susceptability"}, {"title"=>"Diet", "key"=>"diet"}...


[register]https://api.tiptap.com/oauth/applications

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
