# Deployment

Read for environments, replicas, infrastructure, or translating hosting details
into C4. Sources: [deployment view](https://docs.structurizr.com/dsl/cookbook/deployment-view/),
[deployment groups](https://docs.structurizr.com/dsl/cookbook/deployment-groups/),
[language](https://docs.structurizr.com/dsl/language#deploymentenvironment),
[AWS example](https://docs.structurizr.com/dsl/cookbook/amazon-web-services/),
[pattern catalog](https://docs.structurizr.com/dsl/patterns/).

## Logical model first, instances second

Declare software systems, containers, and their logical dependencies first. Then
use `deploymentEnvironment "Name" { ... }` in the model to define physical/runtime
placement. The environment name or its identifier selects a deployment view.
An environment without nodes/instances cannot produce meaningful deployment detail.

```text
deploymentNode <name> [description] [technology] [tags] [instances]
infrastructureNode <name> [description] [technology] [tags]
softwareSystemInstance <systemId> [deploymentGroups] [tags]
containerInstance <containerId> [deploymentGroups] [tags]
instanceOf <systemOrContainerId> [deploymentGroups] [tags]
healthCheck <name> <url> [intervalSeconds] [timeoutMilliseconds]
```

Nest deployment nodes for relevant containment: cloud/region/cluster/node/process,
for example. Inside nodes, place child nodes, infrastructure nodes, and instances.
Instances refer to existing logical objects; they are not new containers. A
`softwareSystemInstance` is useful when a dependency's implementation is opaque.
`instanceOf` is an alias chosen from the referenced element type; explicit instance
keywords often make intent clearer.

`instances` on a deployment node is a count/range (e.g. `2`, `1..N`), not a new
logical C4 container. Explicit instance declarations are needed when separate
identities, connectivity, placement, or tags matter. Health checks belong to a
software-system/container instance; defaults are 60 seconds interval and 0 ms
timeout. They describe runtime checks, not a parser-validation endpoint.

Instances inherit logical-element tags plus their instance type tag, so a style
on `Container` can affect its deployed instances. Instance-level tags distinguish
placements without changing the logical application.

## Relationship replication and deployment groups

Logical relationships are automatically replicated between instances in the same
environment. Two complete copies of an API/database pair can otherwise receive
cross-copy arrows. A visual group or a shared deployment node does not isolate
that traffic. Define deployment groups and assign corresponding instances to the
same group to express independent copies:

```dsl
production = deploymentEnvironment "Production" {
    blue = deploymentGroup "Blue"
    green = deploymentGroup "Green"
    deploymentNode "Blue host" "Blue service copy." "Linux" {
        containerInstance shop.api blue
        containerInstance shop.ledger blue
    }
    deploymentNode "Green host" "Green service copy." "Linux" {
        containerInstance shop.api green
        containerInstance shop.ledger green
    }
}
```

This fragment assumes `shop.api -> shop.ledger` already exists. A comma-separated
list of deployment-group identifiers can associate an instance with several
groups for intentionally shared services. In hierarchical mode, use the correct
fully qualified group reference when outside its local scope.

The current cookbook also shows `deploymentGroup groupId` inside a deployment node
to supply group membership to its descendants. This is distinct from declaring
`groupId = deploymentGroup "Name"` at environment level. Verify this shorthand
against the installed parser; explicit instance memberships are easier to audit.

Logical instance-to-instance arrows are generated, not normally authored as
`instanceA -> instanceB`. Infrastructure nodes can have explicit connections to
deployment nodes, infrastructure nodes, and system/container instances; instances
can explicitly connect to infrastructure nodes. Deployment nodes connect to other
deployment nodes. Do not mix logical and physical endpoint types to bypass these
rules. When uncertain, check the matching parser's allowed endpoint types.

The newer `-/>` operator removes deployment relationships. It changes the model,
unlike view `exclude`. **It is rejected by the tested `2026.06.28` parser.** Prefer
deployment groups on that runtime; do not silently require an upgrade.

The public [upstream parser](https://github.com/structurizr/structurizr/blob/main/structurizr-dsl/src/main/java/com/structurizr/dsl/NoRelationshipParser.java)
specifies `source -/> destination [description]` inside a deployment environment.
In that implementation, endpoints may be logical systems/containers (selecting
their instances in the environment) or individual instances. An optional
description narrows matching replicated relationships; no match is an error.
Declare the instances first. This source-derived grammar is newer than the tested
runtime: validate it on the intended version before use, and do not generalize it
to removing arbitrary logical-model relationships.

## Deployment views

```dsl
deployment shop production "shop-production" {
    include *
    autoLayout lr
    title "Shop - Production Deployment"
}
```

The environment is required and must already exist. `*` scope includes deployment
content across systems in that environment; system scope restricts logical
instances to that system while admitting deployment/infrastructure nodes.
Use instance/node identifiers for explicit selection, not the logical container
identifier as a substitute. Review enclosing nodes and relationships in parsed
JSON when narrowing a view.

## Infrastructure modeling decisions

- Kubernetes clusters/nodes/pods and Docker hosts/runtimes are deployment nodes;
  the application running there remains the logical container. Omit infrastructure
  layers that do not help answer the diagram's question.
- Firewalls, load balancers, DNS, and managed gateways usually belong as
  infrastructure nodes. When actual intermediary routing matters, show it here;
  do not universally collapse such nodes into a direct dependency.
- A function handler can be a logical container, with its managed runtime modeled
  in deployment. AWS App Runner, EKS, and Fargate likewise describe hosting.
- Cloud/provider themes decorate elements using exact tags; they do not create
  the model or determine whether something is a system, container, or node.

Use official [Kubernetes](https://docs.structurizr.com/dsl/patterns/kubernetes/),
[Docker](https://docs.structurizr.com/dsl/patterns/docker/),
[gateway](https://docs.structurizr.com/dsl/patterns/api-gateway/),
[Lambda](https://docs.structurizr.com/dsl/patterns/aws-lambda/), and
[microservice](https://docs.structurizr.com/dsl/patterns/microservice/)
patterns as alternatives to assess, not compulsory templates for every system.
