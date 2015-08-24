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

The size limit for source images is 10MB.

## Polling

If the request is accepted you will receive an HTTP 202 Accepted response.
The `Location` header will contain a URL to poll.

Poll the URL returned in the `Location` header until it returns 303 (See
Other). When it returns 303, the image is finished processing and the
`Location` header will contain the URL of the image. Under normal
circumstances creation of the image should be instantaneous.

If there was an error processing the image, the `error` field in the
JSON response will contain an error message. If the `error` field is null,
no error has occurred. If there is an error message, the client should stop
polling.

### Polling Responses

* 200 - The image is still being processed. Keep polling.
* 303 - The image is finished. Its URL is in the `Location` header.
* 404 - Image not found.

## Composite Source Images

Urls can be multiple image urls to combine vertically (using '|') or
horizontally (using '[]'). These can also be chained together.

For example the url `http://a.com/1.jpg|http://a.com/2.jpg[]http://a.com/3.jpg`
will produce this image:

```
+---------------+
|     1.jpg     |
+-------+-------+
| 2.jpg | 3.jpg |
+-------+-------+
```

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
    parsed_body = JSON.parse(poll_response.body)
    fail(parsed_body['error']) if parsed_body['error']
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
