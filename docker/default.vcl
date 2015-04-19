vcl 4.0;

backend default {
  .host = "127.0.0.1";
  .port = "9292";
}

sub vcl_recv {
  if (req.method == "GET" &&
      req.url ~ "^/((gend|src)_thumbs/\d+|(gend|src)_images/[\w-]{6,})$") {
      unset req.http.Cookie;
  }
}
