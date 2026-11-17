# Deck Auto Dock

Automatically switches your Steam Deck to **Desktop Mode** when docked to an external monitor, and returns to **Gaming Mode** when unplugged.

## Repository Structure

* `README.md` — Documentation and installation instructions.
* `deckautodock.sh` — Shell script that checks display status and switches SteamOS sessions.
* `99-deckautodock.rules` — Udev rule that triggers the script on display hotplug events.

## How It Works (System Interfaces)

* **Linux Kernel DRM (`/sys/class/drm`):** Exposes display connector statuses (`connected` / `disconnected`) for external DisplayPort/HDMI outputs.
* **`udev` & `systemd-run`:** Listens for kernel `HOTPLUG` hardware events on the `drm` subsystem and launches the script asynchronously in the background so it is not terminated during a session restart.
* **SteamOS Session Manager (`steamos-session-select`):** Tells SteamOS which graphical session to boot into (`gamescope` for Gaming Mode, `plasma-wayland-persistent` or `plasma-x11-persistent` for Desktop Mode).
* **Active Compositor / Shell (`gamescope-session` & `plasmashell`):** Checked via `pgrep` to verify which environment is currently running before triggering a switch.

## Installation

1. **Copy the shell script to your user's local bin directory and make it executable:**
   ```bash
   mkdir -p ~/.local/bin
   cp dock-to-desktop.sh ~/.local/bin/dock-to-desktop.sh
   chmod +x ~/.local/bin/dock-to-desktop.sh
   ```

2. **Install the udev rule:**
   ```bash
   sudo cp 99-dock-desktop.rules /etc/udev/rules.d/99-dock-desktop.rules
   ```

3. **Reload udev rules to apply changes:**
   ```bash
   sudo udevadm control --reload-rules
   ```

## Usage

Plug your Steam Deck into a dock connected to an active monitor to enter Desktop Mode. Unplug the dock to return to Gaming Mode.

## Uninstall

1. **Remove the udev rule and script:**
   ```bash
   sudo rm -f /etc/udev/rules.d/99-dock-desktop.rules
   rm -f ~/.local/bin/dock-to-desktop.sh
   ```

2. **Reload udev rules:**
   ```bash
   sudo udevadm control --reload-rules
   ```
