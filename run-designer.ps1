# --- Configuration ---
$IMAGE_NAME = "adrianux2/pyqt-designer:pyqt5-opencv-4_10"
$CONTAINER_HOME = "/home/developer"
$LOCAL_DIR = Get-Location

# --- Récupération de l'IP Windows pour MobaXterm ---
# MobaXterm écoute généralement sur l'IP de l'hôte Windows.
# Si $env:DISPLAY est vide, on essaie de le construire.
if (-not $env:DISPLAY) {
    $IP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
    ($_.InterfaceAlias -like "*vEthernet (WSL)*" -or $_.InterfaceAlias -like "*Ethernet*") -and
    ($_.IPAddress -match "^192\.168\." -or $_.IPAddress -match "^10\.")
}).IPAddress | Select-Object -First 1
    $DISPLAY_VAL = "$($IP):0.0"
} else {
    $DISPLAY_VAL = $env:DISPLAY
}

# --- Arguments Docker ---
$DOCKER_ARGS = @(
    "-it", "--rm",
    "-v", "${LOCAL_DIR}:${CONTAINER_HOME}",
    "-e", "DISPLAY=$DISPLAY_VAL",
    "-e", "QT_QPA_PLATFORM=xcb",
    "-e", "HOME=${CONTAINER_HOME}",
    "-w", "${CONTAINER_HOME}"
)

# --- Lancement ---
Write-Host "--- Mode : MobaXterm X11 Server ($DISPLAY_VAL) ---" -ForegroundColor Cyan
docker run $DOCKER_ARGS $IMAGE_NAME $args
