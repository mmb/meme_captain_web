The Meme Captain API is currently experimental and may change.

# Searching Source Images

HTTP GET https://memecaptain.com/api/v3/src_images.

## Query String parameters

- page - result set page
- q - search string

## curl example

```sh
curl -s 'https://memecaptain.com/api/v3/src_images/?q=test&page=1' | jq .
```

```json
[
  {
    "id_hash": "j5k4_g",
    "width": 800,
    "height": 450,
    "size": 9976994,
    "content_type": "image/gif",
    "created_at": "2015-06-11T04:13:03.731Z",
    "updated_at": "2015-06-16T06:14:34.102Z",
    "name": "test2",
    "image_url": "http://i.memecaptain.com/src_images/j5k4_g.gif"
  },
  {
    "id_hash": "VEE7rg",
    "width": 600,
    "height": 800,
    "size": 62411,
    "content_type": "image/jpeg",
    "created_at": "2015-06-11T04:14:37.965Z",
    "updated_at": "2015-06-16T06:14:29.506Z",
    "name": "test1",
    "image_url": "http://i.memecaptain.com/src_images/VEE7rg.jpg"
  }
]
```
