component firefly.explorer "24-explorer-browser" "Component - FireFly Explorer browser application" {
    title "Component - FireFly Explorer browser application"
    include firefly.explorer.app operator firefly.core
    exclude *->*
    include operator->firefly.explorer.app
    include firefly.explorer.app->firefly.core
    autoLayout lr 360 200
}
