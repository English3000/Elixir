## CDN Integration

key-value db (Redis)
relational db
document db (MongoDB) -- like relational, except can't join
graph db (Neo4js = adjacency list)

all just data structures on disk (instead of RAM)

### Cache (often in RAM; not persistent)
* application (Redis & Memcache[d]) vs HTTP
* very fast in-storage memory
* in between client & server

### HTTP (ascii/UTF8)

### CDNs
* spatially located proximal to large pop's
* uses HTTP cache headers to decide how to keep file in cache
* provides invalidation via API

CloudFront will be backed by S3.

### Cache control/expiry
via `"Cache-Control"` http header
* `no-store`
* `no-cache`
* `public`
* `private` = stored only in browser
* `max-age=` seconds
* `must-revalidate`

### Cache validation
config'd via
* etag (fingerprints response, returns hash value) = `if-none-match`
* last-modified (weak validation) = `if-modified-since`
* `vary` = cache multiple copies based on another given header (the key)

### CloudFront
* uses Squid (open-source) under the hood
* can override http headers
* web or real-time media
