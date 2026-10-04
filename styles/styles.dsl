// Shared native C4 notation. More specific rules only change their own concern:
// type -> shape -> ownership -> deployment status.
styles {
    element "Element" {
        shape RoundedBox
        background #DDDDDD
        color #000000
        stroke #8A8A8A
        strokeWidth 2
        border Solid
    }
    element "Person" {
        shape Person
        background #08427B
        color #FFFFFF
        stroke #073B6F
    }
    element "Software System" {
        background #1168BD
        color #FFFFFF
        stroke #3C7FC0
    }
    element "Container" {
        background #438DD5
        color #FFFFFF
        stroke #3C7FC0
    }
    element "Component" {
        background #85BBF0
        color #000000
        stroke #78A8D8
    }
    element "Deployment Node" {
        background #FFFFFF
        color #000000
        stroke #A2A2A2
    }
    element "Infrastructure Node" {
        background #FFFFFF
        color #000000
        stroke #A2A2A2
    }
    element "Boundary" {
        color #444444
        stroke #444444
        border Dashed
    }
    element "Group" {
        color #444444
        stroke #444444
        border Dashed
    }
    element "Database" {
        shape Cylinder
    }
    element "External" {
        background #999999
        color #FFFFFF
        stroke #8A8A8A
    }
    // Absence of a status tag makes no claim about deployment.
    element "Available" {
        border Solid
    }
    element "Planned" {
        border Dashed
    }
    relationship "Relationship" {
        color #666666
        fontSize 18
        thickness 2
        routing Orthogonal
        style Solid
    }
}
