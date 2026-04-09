#!/data/data/com.termux/files/usr/bin/bash
clear
echo "Checking system dependencies..."

if ! command -v python &> /dev/null; then
    echo "Python not found. Installing Python latest version..."
    pkg update && pkg install python -y
else

    VERSION_INT=$(python -c 'import sys; print(sys.version_info.major * 100 + sys.version_info.minor)')
    
    if [ "$VERSION_INT" -lt 313 ]; then
        echo "Python version is older than 3.13. Updating Python..."
        pkg update && pkg upgrade python -y
    else
        echo "Python version is up to date."
    fi
fi

export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

git fetch --all > /dev/null 2>&1

LOCAL_HASH=$(git rev-parse HEAD)
REMOTE_HASH=$(git rev-parse origin/main)

if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
    echo "Updating Tool..."
    
    git reset --hard origin/main
    git clean -fd
    
    echo "Update successful."
fi

if [ -f "./fastclone" ]; then
    chmod +x ./fastclone
    ./fastclone "$@" 2>/dev/null
else
    echo "Error: 'fastclone' binary not found. Run Full Command Again."
fi
