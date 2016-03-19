The Meme Captain API is currently experimental and may change.

# Creating a Meme Image

HTTP POST a JSON body to https://memecaptain.com/api/v3/gend_images. Set the
`Content-Type` header to `application/json`.

Example JSON body:

```json
{
  "src_image_id": "MDyuQg",
  "private": false,
  "captions_attributes": [
    {
      "text": "top text",
      "top_left_x_pct": 0.05,
      "top_left_y_pct": 0,
      "width_pct": 0.9,
      "height_pct": 0.25
    },
    {
      "text": "bottom text",
      "top_left_x_pct": 0.05,
      "top_left_y_pct": 0.75,
      "width_pct": 0.9,
      "height_pct": 0.25
    }
  ]
}
```

## Required Fields

* src_image_id
* text
* top_left_x_pct
* top_left_y_pct
* width_pct
* height_pct

## Caption Coordinates

The top left corner of the image has the coordinates (0, 0).

- top_left_x_pct - the x coordinate of the top left corner of the caption as a percentage of the total image width
- top_left_y_pct - the y coordinate of the top left corner of the caption as a percentage of the total image height
- width_pct - the width of the caption as a percentage of the total image width
- height_pct - the height of the caption as a percentage of the total image height

## Polling

If the request is accepted you will receive an HTTP 200 response with a JSON
body. The `status_url` field in the body will contain a URL to poll.

Poll the URL returned in the `status_url` field until the JSON field
`in_progress` in the response body is false.

If the `error` field is null, the request was successful and the URL of the
created image can be found in the `url` field. If the request failed the `error`
field will contain an error message. Under normal circumstances creation of the
image should be instantaneous.

## Error Responses

If the src_image_id in the initial POST request references a source image
that is not found or is not finished being created, the response code will
be 404.

If there are validation errors the response code will be 422 Unprocessable Entity. The body will contain JSON with the errors.

## Shell script example

On every meme image page, there is an `API` button that shows a shell script
that recreates that image using the API. This script can also be used to
determine text position parameters for an API request.

## Ruby example

```ruby
#!/usr/bin/env ruby

require 'json'
require 'net/http'

json_request = {
  src_image_id: 'IGFkHg',
  private: false,
  captions_attributes: [
    {
      text: 'top text',
      top_left_x_pct: 0.05,
      top_left_y_pct: 0,
      width_pct: 0.9,
      height_pct: 0.25
    },
    {
      text: 'bottom text',
      top_left_x_pct: 0.05,
      top_left_y_pct: 0.75,
      width_pct: 0.9,
      height_pct: 0.25
    }
  ]
}

create_uri = URI('https://memecaptain.com/api/v3/gend_images')
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
