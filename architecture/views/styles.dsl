styles {
    element "Element" {
        color #122C43
        stroke #57718A
        strokeWidth 2
        fontSize 22
        width 360
        height 220
    }
    element "Person" {
        shape Person
        background #173F5F
        color #FFFFFF
    }
    element "Software System" {
        background #176B87
        color #FFFFFF
    }
    element "Container" {
        background #DCECF7
    }
    element "Component" {
        background #EEF5FA
    }
    element "Group" {
        color #42566A
        stroke #8295A7
        border Dashed
        fontSize 26
    }
    element "Database" {
        shape Cylinder
        background #E8E4F5
    }
    element "Private" {
        stroke #8C4966
    }
    element "Shared" {
        stroke #237A69
    }
    element "Blockchain" {
        background #EFE4C8
        stroke #9B782E
        color #122C43
    }
    element "Contract" {
        background #FFF3D3
    }
    element "Optional" {
        background #F0F0F0
        stroke #7A7A7A
        border Dashed
        color #122C43
    }
    element "Operational" {
        background #E8EEEE
        stroke #59736C
    }
    element "LogicalReference" {
        stroke #566C82
        border Dashed
    }
    element "ReferenceIntegration" {
        stroke #8A6623
        border Dashed
    }
    relationship "Relationship" {
        color #476177
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed false
    }
    relationship "PrivateFlow" {
        color #8C4966
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed false
    }
    relationship "SharedFlow" {
        color #237A69
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed false
    }
    relationship "BlockchainFlow" {
        color #967228
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed false
    }
    relationship "Operational" {
        color #6D817A
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed true
    }
    relationship "Alternative" {
        color #888888
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed true
    }
    relationship "IdentityFlow" {
        color #285D9F
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed false
    }
    relationship "DirectoryFlow" {
        color #277668
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed false
    }
    relationship "SecretFlow" {
        color #874C84
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed false
    }
    relationship "KeyFlow" {
        color #946B20
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed false
    }
    relationship "PrivilegedFlow" {
        color #A34532
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed false
    }
    relationship "SecurityAdminFlow" {
        color #607080
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed false
    }
    relationship "ReferenceIntegration" {
        color #8A6623
        fontSize 18
        thickness 2
        routing Orthogonal
        dashed true
    }
    // Preserve the shared palette; give the richer Unleash labels adequate space.
    element "UnleashCatalog" {
        width 480
        height 300
    }
    relationship "UnleashCatalog" {
        routing Curved
    }
}
