"""Compatibility entrypoint for transactional components evidence refresh."""
from refresh_evidence import main

if __name__ == "__main__":
    raise SystemExit(main("Components"))
