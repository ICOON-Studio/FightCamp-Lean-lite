"""The card game page's local server (S549). Plain `python -m http.server` sends no cache header, so the browser kept
an old floor.mjs beside a new moves.mjs after an edit and the page stayed on LOADING. This one tells the browser never
to keep a file: a reload always plays the files on disk.  python proto/cardgame/serve.py [port]"""
import http.server
import os
import sys


class NoCache(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def log_message(self, *a):
        pass

    def translate_path(self, path):   # S574: /octagon/... is proto/octagon (the card game's engine) from any root
        if path.startswith('/octagon/'):
            return os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'octagon', path[len('/octagon/'):].split('?')[0].split('#')[0])
        return super().translate_path(path)


if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    os.chdir(os.path.join(here, '..', sys.argv[2]) if len(sys.argv) > 2 else here)   # [port] [sibling folder, e.g. boxcards]
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8799
    http.server.ThreadingHTTPServer(("127.0.0.1", port), NoCache).serve_forever()
