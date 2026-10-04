# Approved platform definitions

This directory is reserved for reviewed platform system definitions. It currently
contains no DSL definitions: `dapp_platform` belongs to ignition. Existing
FireFly, Besu, security, operations and application examples remain references;
they do not define the new platform's ownership.

After review, move accepted definitions here, preserve identifiers, and include
their system entrypoints before the shared relationship folder. Keep any imported
directory limited to DSL fragments in one scope; do not import this README as DSL.
Remove old initiative definitions in the same change and validate every workspace.

Approved shared views belong in `views/platform/`; reusable behavioral diagrams
belong in `uml/`. See the [promotion workflow](../../README.md#variants-and-promotion).
