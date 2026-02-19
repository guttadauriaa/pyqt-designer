#!/bin/bash

# --- Configuration ---
IMAGE_NAME="pyqt-designer:linux"
CONTAINER_HOME="/home/$USER"
LOCAL_DIR="$(pwd)"

# --- Détection de SELinux ---
# Sur Fedora, 'getenforce' renvoie 'Enforcing' ou 'Permissive'
if command -v getenforce >/dev/null 2>&1 && [ "$(getenforce)" != "Disabled" ]; then
    echo "--- SELinux détecté : Activation du flag :Z sur les volumes ---"
    Z_OPT=",z"  # Utilisation d'une virgule pour les options combinées
    Z_FLAG=":Z" # Pour les volumes simples
    PRIV_OPT="--privileged"
else
    Z_OPT=""
    Z_FLAG=""
    PRIV_OPT=""
fi

# --- Initialisation des arguments Docker ---
DOCKER_ARGS=(
    -it --rm
    $PRIV_OPT                # Garantit l'accès aux pilotes graphiques et aux sockets
    --user "$(id -u):$(id -g)"
    -v "/etc/passwd:/etc/passwd:ro"
    -v "/etc/group:/etc/group:ro"
    -v "$LOCAL_DIR:$CONTAINER_HOME"
    -e HOME="$CONTAINER_HOME"
    -w "$CONTAINER_HOME"
    --group-add $(getent group video | cut -d: -f3)
    --device=/dev/video0:/dev/video0
)

# --- Détection de l'environnement d'affichage ---

if [ -n "$WAYLAND_DISPLAY" ]; then
    echo "--- Mode : Wayland (Natif) ---"
    DOCKER_ARGS+=(
        -e WAYLAND_DISPLAY="$WAYLAND_DISPLAY"
        -e XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR"
        -v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
        -e QT_QPA_PLATFORM=wayland
        --privileged
    )
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "--- Détection : macOS (XQuartz) ---"
    # Autoriser les connexions locales
    xhost +localhost > /dev/null
    DOCKER_ARGS+=(
        -e DISPLAY="host.docker.internal:0"
        -e QT_QPA_PLATFORM=xcb
    )
elif [ -n "$DISPLAY" ]; then
    echo "--- Mode : X11 (via XWayland ou Natif) ---"
    # Autoriser Docker à accéder au serveur X local
    xhost +local:docker > /dev/null
    
    # Si on est sur WSL ou Windows, DISPLAY contient souvent une IP ou :0
    DOCKER_ARGS+=(
        -e DISPLAY="$DISPLAY"
        -v /tmp/.X11-unix:/tmp/.X11-unix
        -e QT_QPA_PLATFORM=xcb
    )
else
    echo "Erreur : Aucun serveur graphique détecté (\$DISPLAY ou \$WAYLAND_DISPLAY)."
    exit 1
fi

# --- Lancement ---
echo "Lancement du conteneur..."
docker run "${DOCKER_ARGS[@]}" "$IMAGE_NAME" "$@"


