The Meme Captain API is currently experimental and may change.

A source image is an image that can be used to create a meme.

# Creating a Source Image from a URL

HTTP POST a JSON body to http://memecaptain.com/src_images. For this
request set the `Accept` and `Content-Type` headers to `application/json`.
Example JSON body:

```json
{
  "url": "http://images.com/image.jpg",
  "name": "my image",
  "private": false
}
```

## Parameters

- url - the URL of the image to load
- name - the name of the source image (optional)
- private - true if the source image is private (optional) 

## Polling

If the request is accepted you will receive an HTTP 202 Accepted response.
The `Location` header will contain a URL to poll.

Poll the URL returned in the `Location` header until it returns 303 (See
Other). When it returns 303, the image is finished processing and the
`Location` header will contain the URL of the image. Under normal
circumstances creation of the image should only take a few seconds.

## Ruby example

```ruby
#!/usr/bin/env ruby

require 'json'
require 'net/http'

json_request = {
  url: 'http://images.com/image.jpg',
}

create_uri = URI('http://memecaptain.com/src_images')
create_request = Net::HTTP::Post.new(create_uri)
create_request['Accept'] = 'application/json'
create_request['Content-Type'] = 'application/json'
create_request.body = json_request.to_json

Net::HTTP.start(create_uri.hostname, create_uri.port) do |http|
  create_response = http.request(create_request)

  poll_uri = URI(create_response['Location'])
  poll_request = Net::HTTP::Get.new(poll_uri)
  10.times do
    poll_response = http.request(poll_request)
    puts "poll response #{poll_response.code}"
    if poll_response.code == '303'
      puts poll_response['Location']
      break
    end
    sleep 3
  end
end
```

# Creating a Source Image from an Uploaded File

Coming soon.
