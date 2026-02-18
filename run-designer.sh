#!/bin/bash

# --- Configuration de l'image ---
IMAGE_NAME="pyqt-designer:linux"
CONTAINER_HOME="/home/$USER"
LOCAL_DIR="$(pwd)"

# --- Initialisation des arguments Docker ---
DOCKER_ARGS=(
    -it --rm
    --user "$(id -u):$(id -g)"
    -v "/etc/passwd:/etc/passwd:ro"
    -v "/etc/group:/etc/group:ro"
    -v "$LOCAL_DIR:$CONTAINER_HOME"
    -e HOME="$CONTAINER_HOME"
    -w "$CONTAINER_HOME"
)

# --- Détection de l'environnement d'affichage ---

if [ -n "$WAYLAND_DISPLAY" ]; then
    echo "--- Détection : Wayland (Linux) ---"
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
    echo "--- Détection : X11 (Linux ou Windows) ---"
    # Autoriser Docker à accéder à X11
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


