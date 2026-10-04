container entraId "100-security-entraId-containers" "Container - Microsoft Entra ID logical reference" {
    title "Container - Microsoft Entra ID logical reference"
    include element.parent==entraId securityAdmin apps.client business adDs.directory
    autoLayout lr 360 200
}
