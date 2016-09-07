The Meme Captain API is currently experimental and may change.

# Searching Meme Images

HTTP GET https://memecaptain.com/api/v3/gend_images.

## Query String parameters

- page - result set page
- q - search string

## curl example

```sh
curl -s 'https://memecaptain.com/api/v3/gend_images/?q=test&page=1' | jq .
```

```json
[
  {
    "content_type": "image/jpeg",
    "created_at": "2016-09-06T06:14:06.829Z",
    "height": 473,
    "image_url": "https://i.memecaptain.com/gend_images/F1peSA.jpg",
    "size": 16432,
    "thumbnail_url": "https://memecaptain.com/gend_thumbs/279888.jpg",
    "updated_at": "2016-09-06T06:14:08.682Z",
    "width": 600,
    "captions": [
      {
        "height_pct": 0.25,
        "text": "test",
        "top_left_x_pct": 0.05,
        "top_left_y_pct": 0,
        "width_pct": 0.9
      },
      {
        "height_pct": 0.25,
        "text": "test",
        "top_left_x_pct": 0.05,
        "top_left_y_pct": 0.75,
        "width_pct": 0.9
      }
    ]
  }
]
```
