# Official source inventory

This covers the documented open-source FireFly ecosystem. Every implementation file in the selected FireFly runtime repositories is mapped to a component responsibility or explicitly classified. This is evidence coverage, not a code-level diagram.

## Pinned repository snapshots

| Repository | Commit | Evidence |
|---|---|---|
| firefly | [9d20f3081c90](https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d) | source archive + documentation |
| evmconnect | [6e12bb4c0506](https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8) | source archive + documentation |
| fftm | [5915cbc4e0e3](https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321) | source archive + documentation |
| signer | [cfafd71fb4d2](https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d) | source archive + documentation |
| dx | [b6a212d531da](https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052) | source archive + documentation |
| erc20 | [7993b308284a](https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9) | source archive + documentation |
| erc1155 | [0355a0eb11fd](https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469) | source archive + documentation |
| besu | [7e05c2342404](https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1) | documentation + repository tree |
| ui | [658bae40220f](https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5) | source archive + documentation |
| sandbox | [ef7f240b8acf](https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069) | source archive + documentation |
| common | [b91a1eb645e5](https://github.com/hyperledger-firefly/common/tree/b91a1eb645e5bc39c54ed20ad0e917cff7d15d2e) | source archive + documentation |
| ethconnect | [e8ae0eda16cc](https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0) | source archive + documentation |
| fabconnect | [efab8a2b0ff1](https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b) | source archive + documentation |
| tezosconnect | [508ec1e8bb8b](https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b) | source archive + documentation |
| cardano | [0300bca6b0b9](https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e) | source archive + documentation |
| cordaconnect | [6579ca46e0d4](https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640) | source archive + documentation |
| cli | [9b868d3326ba](https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609) | source archive + documentation |
| perf | [3d3ec0242b23](https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9) | source archive + documentation |
| sdk | [c4e813bc611f](https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172) | source archive + documentation |
| samples | [e71a5c1dfd7a](https://github.com/hyperledger-firefly/samples/tree/e71a5c1dfd7a7eb9b1590c9023b905df6273905d) | documentation + repository tree |
| evmsigner | [cfafd71fb4d2](https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d) | documentation + repository tree |
| tezosfftm | [7a882ddaeaf2](https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9) | source archive + documentation |

Retrieved: 2026-09-18T21:02:48.224172+00:00

## Embedded versions

| Owning runtime | Library | Version |
|---|---|---|
| evmconnect | fftm | [v1.5.4-0.20260911112148-5915cbc4e0e3](https://raw.githubusercontent.com/hyperledger-firefly/evmconnect/6e12bb4c050677780cf5dd975a926923868b0cb8/go.mod) |
| evmconnect | evmsigner | [v1.2.2-0.20260914155424-cfafd71fb4d2](https://raw.githubusercontent.com/hyperledger-firefly/evmconnect/6e12bb4c050677780cf5dd975a926923868b0cb8/go.mod) |
| firefly | common | [v1.6.3](https://raw.githubusercontent.com/hyperledger-firefly/firefly/9d20f3081c9074d5b012427e5572ebc03da8d95d/go.mod) |
| tezosconnect | tezosfftm | [v1.3.20](https://raw.githubusercontent.com/hyperledger-firefly/tezosconnect/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/go.mod) |
| sandbox | sdk | [1.3.0](https://raw.githubusercontent.com/hyperledger-firefly/sandbox/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/server/package-lock.json) |

## Coverage and evidence limits

- 2595 source files inventoried; 0 unclassified implementation files.
- Core plugin factories are checked through the captured factory sources and concrete adapter components. The onchain identity implementation is a placeholder.
- Corda starter CorDapps and Cardano demo/key-generation tools are customization/example artifacts; they are not services in the selected Besu stack.
- The official samples repository is cataloged as example applications represented by the member-application boundary; it is not a mandatory runtime.
- Explorer is served by Core. The UI source snapshot is a reference implementation; Core does not pin a UI source commit in its Dockerfile.
- Signer ABI/RLP/EIP-712 utilities, common helpers, SDKs and public interfaces are mapped to owning responsibilities, without claiming independent services.
- Besu source modules are mapped to its focused node views. Security products have separate documentation-backed logical reference coverage; their proprietary implementation files are not inventoried.
- Relationship rows state architecture-level dataflow inferred from the cited source responsibilities. They do not claim every arrow is one direct method call.
- Tezos embeds FFTM v1.3.20; it is not silently assigned EVMConnect's FFTM revision.
- Alternative EVM chain guides reuse the Ethereum adapter rather than duplicating its implementation.

## Official documentation

- [firefly-head](https://hyperledger-firefly.github.io/firefly/head/)
- [firefly-architecture](https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/)
- [firefly-plugins](https://hyperledger-firefly.github.io/firefly/head/architecture/plugin_architecture/)
- [qbft](https://docs.besu-eth.org/private-networks/how-to/configure/consensus/qbft)
- [permissioning](https://docs.besu-eth.org/private-networks/concepts/permissioning)
- [besu-rpc](https://docs.besu-eth.org/private-networks/reference/api)
- [structurizr-dsl](https://docs.structurizr.com/dsl/language)
- [inspect](https://docs.structurizr.com/inspect)

## Security product reference catalog

Proprietary component decompositions are logical reference abstractions, not a verified internal code inventory. Proposed application integrations are labeled separately. Conjur Enterprise (Secrets Manager Self-Hosted) is the selected edition.

Retrieved: 2026-09-18T22:15:54.002044+00:00

| Documentation | Capture method | SHA-256 |
|---|---|---|
| [security-keycloak](https://www.keycloak.org/docs/latest/server_admin/index.html) | Direct HTTP document snapshot | `ce87c66f5f1a887ffb22ea24313a0668a58b73cc5ebf51f5497ac6d84a41af84` |
| [security-keycloak-db](https://www.keycloak.org/server/db) | Direct HTTP document snapshot | `9e6f0eed2218d84f8f6098b9d47cfcc2b8c4ff591acf9e5d933110f0b3e6470d` |
| [security-hsm](https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control) | Direct HTTP document snapshot | `ad2692cf94269baf3964a5f80269bb16acee0124a021396b42e70a6c93fe1655` |
| [security-hsm-keys](https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details) | Direct HTTP document snapshot | `91bc8fcb945dddc9a31a92748a2f4e4c4aabf4458c02e1df33d544c93456b367` |
| [security-pam](https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm) | Web reader text excerpt; direct HTTP returned 404 | `6a0621e38fd4177824c4e09e6b8e0671dcc30eb7a5fb5b478b813c7e1b287a91` |
| [security-conjur](https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm) | Web reader text excerpt; direct HTTP returned 404 | `42f1cd43bcd2d4a8c59fa581c415f86fa13b1ef8ccff14cdc551feeb16241a92` |
| [security-conjur-sync](https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm) | Web reader text excerpt; direct HTTP returned 404 | `e911448c310c2262dfde5c4648ed9e4257cdf40226f18460adb901f11d89f564` |
| [security-entra](https://learn.microsoft.com/en-us/entra/architecture/architecture) | Direct HTTP document snapshot | `03c14d79d6d3c6944ce9f1a6de19e2176b827847f33d9f1eaef25e32bf561862` |
| [security-entra-oidc](https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc) | Direct HTTP document snapshot | `d04152c39a3a2263d5a0400a61db1e7f244646be5335fe98a2c81b5043df3d7f` |
| [security-cloud-sync](https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync) | Direct HTTP document snapshot | `5e9eeb26a2ba1462263f630c5a3a9c54cf0820c6a3040ac266912d8247ba8eab` |
| [security-ad](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) | Direct HTTP document snapshot | `a3cf89073c73c99a6d3905595600119e2fcbfafb2048b771e749d3edddd56ab0` |
| [security-adfs](https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview) | Direct HTTP document snapshot | `0d5bfd1b8af15e99a015f12fe854e2d7b3d4ef58f1abd5aeeee9738fedf79c15` |
| [security-adfs-claims](https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine) | Direct HTTP document snapshot | `e2f35654d993488046a922b60f00b979cdc34d76bbcc312d9e112960e21c84f6` |
| [security-ethereum-transactions](https://ethereum.org/en/developers/docs/transactions/) | Direct HTTP document snapshot | `fa51f2287f87125387e1add01d028ed8d077d646625367e0ee317655c477b4ac` |

CyberArk entries use web-reader text excerpts because direct HTTP downloads returned 404. Fingerprints describe those excerpts; they are not full HTML snapshots.

[Security element-to-document coverage](security-source-coverage.csv). Broad product documentation supports capabilities; grouping those capabilities into logical components is explicitly inferred.
