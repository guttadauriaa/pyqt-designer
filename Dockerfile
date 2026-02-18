FROM python:3.11-slim

# Évite les interactions lors de l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Installation des dépendances système pour Qt, Wayland et OpenGL
RUN apt-get update && apt-get install -y \
    qttools5-dev-tools \
    qt5-qmake \
    pyqt5-dev-tools \
    python3-pyqt5 \
    python3-pip \
    libgl1 \
    libglx-mesa0 \
    libegl1 \
    libdbus-1-3 \
    libglib2.0-0 \
    libwayland-client0 \
    libwayland-cursor0 \
    libwayland-egl1 \
    libxkbcommon-x11-0 \
    libxcb-cursor0 \
    libqt5gui5 \
    && rm -rf /var/lib/apt/lists/*

# Installation des bibliothèques Python scientifiques
RUN pip install --no-cache-dir \
    PyQt5 \
    pyqt5-tools \
    matplotlib \
    numpy \
    scipy \
    scikit-learn \
    scikit-image

# Configuration pour Wayland
#ENV QT_QPA_PLATFORM=wayland  # pas si l'on veut l'utiliser avec X11
ENV XDG_RUNTIME_DIR=/tmp/runtime-dir

WORKDIR /app

# Lancer Designer par défaut (ou peut être écrasé à l'exécution)
CMD ["bash"]

