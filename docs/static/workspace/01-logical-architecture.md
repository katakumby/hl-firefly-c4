# FireFly ecosystem: C4 levels 1–3

This workspace describes the documented open-source FireFly ecosystem and a
private Besu example. The validated entrypoint is **workspace-static.dsl**.
The main workspace retains the previous deployment definitions for a later
review. No deployment, availability-zone, recovery, quorum-sizing or export
claim from the earlier reports is renewed by this validation.

Start with 01-landscape and 02-context-firefly, then 10-firefly-runtime for the
Besu configuration. Core responsibilities are split across 20–23 component
views; EVMConnect, Signer, Data Exchange and token connectors use 30–40 views.
Besu details use 50–51. Tools use 61–65. Optional blockchain configurations use
70–76. View titles state their C4 level and selected configuration.

Core hosts its Explorer UI and statically compiled plugin adapters. Independent
connectors are containers. FFTM is embedded in EVMConnect and TezosConnect, with
each connector's own dependency version recorded in sources.json. SDKs, shared
HTTP libraries, ABI/cryptographic utilities and factories are embedded
responsibilities, not additional services. SQLite and LevelDB boxes represent
files owned by a process, not database servers.

FireFly and Besu receive component-level detail. Other ledger, database, broker,
signing-provider and infrastructure implementations stop at integration
boundaries. This does not claim to inventory arbitrary vendor plugins or every
application that could be built with FireFly. Samples and CorDapps are recorded
as examples/customization points in the source inventory.

The open-source identity plugin is an unfinished onchain compatibility
placeholder, not an operational DID resolution service. CordaConnect is a
starter requiring CorDapp customization and a Core binding; it is not shown as
an already registered Core blockchain plugin. EthConnect is the legacy EVM
option. Alternative configurations are not requirements of the Besu example.

Node fill identifies person/system/container/component; cylinders identify
stores. Dashed grey boxes/relationships denote optional integrations. Gold
identifies blockchain/contract responsibilities; purple and green distinguish
private and shared data. Arrow labels and protocol metadata carry the meaning
independently of color. Every view contains directed static relationships.

Source-backed capability coverage is in reports/static/source-inventory.md;
element-to-view coverage is in coverage.csv. Relationship evidence in the model
catalog identifies supporting source responsibilities. Architecture flow
inferences are distinguished from a literal method-call graph. Reference
applications and operational infrastructure are explicitly marked choices.
