The Meme Captain API is currently experimental and may change.

A source image is an image that can be used to create a meme.

# Creating a Source Image from a URL

HTTP POST a JSON body to https://memecaptain.com/api/v3/src_images. Set the
`Content-Type` header to `application/json`.

Example JSON body:

```json
{
  "url": "http://images.com/image.jpg",
  "name": "my image",
  "private": false
}
```

## Parameters

- url - the URL of the image to load (can be a URL or a data URI)
- name - the name of the source image (optional)
- private - true if the source image is private (optional)

The size limit for source images is 10MB.

## Polling

If the request is accepted you will receive an HTTP 200 response with a JSON
body. The `status_url` field will contain a URL to poll.

Poll the URL returned in the `status_url` field until the JSON field
`in_progress` in the response body is false.

If the `error` field is null, the request was successful and the URL of the
created image can be found in the `url` field. If the request failed the `error`
field will contain an error message. Under normal circumstances creation of the
image should be instantaneous.

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

create_uri = URI('https://memecaptain.com/api/v3/src_images')
create_request = Net::HTTP::Post.new(create_uri)
create_request['Content-Type'] = 'application/json'
create_request.body = json_request.to_json

Net::HTTP.start(create_uri.hostname, create_uri.port, use_ssl: true) do |http|
  create_response = http.request(create_request)
  unless create_response.code == '200'
    fail("#{create_response.code}\n#{create_response.body}")
  end
  parsed_create_response = JSON.parse(create_response.body)

  poll_uri = URI(parsed_create_response['status_url'])
  poll_request = Net::HTTP::Get.new(poll_uri)
  10.times do
    poll_response = http.request(poll_request)
    if poll_response.code == '200'
      parsed_poll_response = JSON.parse(poll_response.body)
      unless parsed_poll_response['in_progress']
        fail(parsed_poll_response['error']) if parsed_poll_response['error']
        puts parsed_poll_response['url']
        break
      end
    else
      fail("#{poll_response.code}\n#{poll_response.body}")
    end
    sleep 3
  end
end
```
