sub vcl_recv {
    if (req.request == "GET" &&
        req.url ~ "^/((gend|src)_thumbs/\d+|(gend|src)_images/[\w-]{6,})$") {
        unset req.http.Cookie;
    }
}
