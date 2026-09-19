"""Navigation groups, never additional ownership or deployment boundaries."""

SYSTEM_GROUPS = {
    'FireFly ecosystem': ('firefly', 'tools', 'peerMembers'),
    'EVM ledger networks': ('besu', 'evmNetworks'),
    'Fabric ecosystem': ('fabric', 'fabricCA'),
    'Tezos ecosystem': ('tezos', 'signatory'),
    'Cardano ecosystem': ('cardano', 'blockfrostService'),
    'Legacy connector infrastructure': ('kafkaBroker', 'mongo'),
    'Identity and federation': ('keycloak', 'entraId', 'adDs', 'adFs'),
    'Privileged access and secrets': ('cyberarkPam', 'conjur'),
    'Azure cryptographic services': ('managedHsm', 'azureManagement'),
}


def apply_groups(elements):
    for group, identifiers in SYSTEM_GROUPS.items():
        for identifier in identifiers:
            element = elements[identifier]
            assert element['kind'] == 'softwareSystem' and not element['parent']
            assert 'group' not in element, identifier
            element['group'] = group
    # Application contracts execute inside the EVM host but are not Besu modules.
    for element in elements.values():
        if element['parent'] == 'besu.node':
            element['group'] = ('Hosted application contracts' if 'Contract' in element['tags'].split(',')
                                else 'Besu client implementation')
