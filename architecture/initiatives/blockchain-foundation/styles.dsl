styles {
    element "Deployment Node" {
        background #F7FAFD
        color #17324D
        stroke #90A7BD
        fontSize 24
    }
    element "Infrastructure Node" {
        background #DCECF7
        width 400
        height 260
        fontSize 22
    }
    element "FoundationValidator" {
        background #F3E3B5
        stroke #AD7E27
    }
    element "FoundationRpc" {
        background #DAEAF7
        stroke #39739D
    }
    element "FoundationIntegration" {
        background #DCEDE6
        stroke #3B7661
        width 420
        height 300
        fontSize 20
    }
    element "FoundationStandby" {
        background #F3F5F8
        border Dashed
        stroke #72849A
    }
    element "FoundationGate" {
        background #FFE2CF
        stroke #C25625
        border Dashed
        height 300
    }
    element "FoundationFailed" {
        background #F4DADD
        color #7C2736
        stroke #AF5364
        border Dashed
    }
    relationship "FoundationPeerFlow" {
        color #937026
        routing Direct
        fontSize 17
    }
    relationship "FoundationHsmFlow" {
        color #B5582F
        fontSize 17
    }
    relationship "FoundationRecoveryFlow" {
        color #657889
        dashed true
    }
}
