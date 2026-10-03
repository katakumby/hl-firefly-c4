# Shared product references: C4 levels 1–3

This workspace describes the documented open-source FireFly ecosystem and a
private Besu example. The reference entrypoint is **workspace.dsl**;
initiative workspaces extend the same modular model and select focused views.
Previous deployment definitions are available in Git history and are not
loaded by the workspace. No deployment, availability-zone,
recovery, quorum-sizing or export
claim from the earlier reports is renewed by this validation.

Start with 01-landscape and 02-context-firefly, then 10-firefly-runtime for the
Besu configuration. Core responsibilities are split across 20–23 component
views; EVMConnect, Signer, Data Exchange and token connectors use 30–40 views.
Besu details use 50–51. Tools use 61–68. Optional blockchain configurations use
70–77. Application, tooling and operations contexts use 05–07. Explorer browser
detail uses 24. Security reference products and examples use `100-security-` keys; start
with `100-security-landscape`. View titles state their C4 level and selected
configuration. The security catalog guide provides product navigation.

The independent [Unleash reference](../system/unleash/01-boundary-and-components.md)
uses eight `110-unleash-` views for its browser UI, server, PostgreSQL and
optional OSS Edge. Its [flow catalog](../system/unleash/02-interfaces-and-flows.md)
documents internal exchanges without selecting any consumer integration.

Core serves Explorer assets, but Explorer executes in a separate browser
container. The Sandbox browser and Node.js server are also separate containers.
Core hosts statically compiled plugin adapters. Independent connectors are
containers. Core and FFTM use separate logical PostgreSQL databases; primary and
standby server instances belong to deployment modeling. FFTM is embedded in EVMConnect and TezosConnect, with
dependency evidence retained in the connector DSL definitions. SDKs, shared
HTTP libraries, ABI/cryptographic utilities and factories are embedded
responsibilities, not additional services. SQLite and LevelDB boxes represent
files owned by a process, not database servers.

FireFly and Besu receive source-backed component-level detail. The seven security
products receive documented capability detail, with proprietary decompositions
labeled as logical reference abstractions. Other ledger, database, broker and
infrastructure implementations stop at integration boundaries. This does not
claim to inventory arbitrary vendor plugins or every
application that could be built with FireFly. Samples and CorDapps are recorded
as examples/customization points in the DSL descriptions and evidence properties.

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
Named group outlines organize related systems at the same C4 level; they do not
assert common ownership, tenancy, trust, deployment or required co-installation.
Besu's hosted contract responsibilities have a separate group from native client
implementation components. See the [final review](05-final-review.md).
Security arrow categories distinguish identity, directory, secret, key,
privileged-session and administration data. Dashed reference-integration arrows
identify proposed application examples; dashed logical-reference boxes identify
inferred proprietary responsibility boundaries. Labels and evidence properties
remain authoritative; see the security catalog legend.

The current validation result is in
`build/c4/reference/validation.json`. The parsed
`workspace.json` retains element identifiers and relationship evidence.
Source URLs and evidence properties remain in DSL; removed source inventories
and coverage reports can be inspected in Git history.
Recorded evidence identifies supporting source responsibilities. Architecture flow
inferences are distinguished from a literal method-call graph. Reference
applications and operational infrastructure are explicitly marked choices.
