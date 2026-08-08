#!/usr/bin/env python3
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

class Handler(SimpleHTTPRequestHandler):
    def log_message(self, fmt, *args):
        print(f"[shelltut] {self.address_string()} {fmt % args}")

if __name__ == "__main__":
    server = ThreadingHTTPServer(("0.0.0.0", 8080), Handler)
    print("shelltut demo listening on :8080", flush=True)
    server.serve_forever()
