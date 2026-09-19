"""Compatibility entrypoint for transactional besu evidence refresh."""
from refresh_evidence import main

if __name__ == "__main__":
    raise SystemExit(main("Besu"))
