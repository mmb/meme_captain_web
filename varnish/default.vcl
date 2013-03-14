sub vcl_recv {
    if (req.url ~ "^/(gend|src)_thumbs/[0-9]+$") {
        unset req.http.Cookie;
    }
}
