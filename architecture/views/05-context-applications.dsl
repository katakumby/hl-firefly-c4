systemContext apps "05-context-applications" "System Context - Member application reference" {
    title "System Context - Member application reference"
    include apps business firefly besu
    exclude *->*
    include firefly->besu
    include apps->firefly
    include business->apps
    include firefly->apps
    include apps->besu
    include besu->apps
    autoLayout lr 360 200
}
