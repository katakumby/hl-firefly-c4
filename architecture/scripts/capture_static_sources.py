"""Compatibility entrypoint for transactional static evidence refresh."""
from refresh_evidence import main

if __name__ == "__main__":
    raise SystemExit(main("Static"))
