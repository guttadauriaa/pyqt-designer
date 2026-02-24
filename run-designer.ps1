# --- Configuration ---
$IMAGE_NAME = "adrianux2/pyqt-designer:3.13-slim-pyqt5-opencv-4.10"
$CONTAINER_HOME = "/home/developer"
$LOCAL_DIR = Get-Location

# --- Récupération de l'IP Windows pour MobaXterm ---
# MobaXterm écoute généralement sur l'IP de l'hôte Windows.
# Si $env:DISPLAY est vide, on essaie de le construire.
if ([string]::IsNullOrEmpty($env:DISPLAY)) {
    # On force la récupération de la propriété IPAddress seule
    $IP = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
        $_.InterfaceAlias -like "*WSL*" -or ($_.InterfaceAlias -eq "Wi-Fi" -and $_.Status -eq "Up")
    } | Select-Object -ExpandProperty IPAddress | Select-Object -First 1

    if (-not $IP) {
        $DISPLAY_VAL = "127.0.0.1:0.0"
        Write-Host "⚠️ Aucune IP trouvée, utilisation de localhost" -ForegroundColor Yellow
    } else {
        $DISPLAY_VAL = "$($IP):0.0"
    }
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
