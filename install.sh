
#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Check if the script is being run in Bash
if [[ -z "$BASH_VERSION" ]]; then
	echo "Warning: This script is intended to be run in Bash."
	echo "Please run the script with 'bash install.sh'"
	exit 1
fi

source "$HOME/.local/share/smokies/vars.sh"
source "$SMOKIESH/show-logo.sh" -header
source "$FEATHER_PATH/errors.sh"

# Clear tmp
source "$SMOKIESH/tmp-clear.sh"

# Select
source "$SMOKIESH/sel-comps.sh" generate
source "$SMOKIESH/sel-comps.sh" fetch

echo "The following will be installed:"
for selected in "${FI_SELECTION[@]}"; do
	echo "  · $selected"
done
if ! gum confirm "Proceed?"; then
	echo "Cancelled by user."
	exit 1
fi

gum style --bold --foreground="#DDDD44" "Beginning Installation..."
# Install
for selected in "${FI_SELECTION[@]}"; do
	case "$selected" in
	System*) source "$SMOKIES/packages.sh" ;;
	Auto-Login) source "$SMOKIES/autologin.sh" ;;

	LazyVim) source "$SMOKIES/lazyvim.sh" ;;
	Mullvad*) source "$SMOKIES/mullvad.sh" ;;
	Tor*) source "$SMOKIES/mullvad.sh" tor ;;
	Vintage*) source "$SMOKIES/vintagestory.sh" ;;
	TLP) source "$SMOKIES/tlp.sh" ;;
	Gamemode) source "$SMOKIES/gamemode.sh" ;;

	Desktop*) source "$SMOKIES/desktops.sh" ;;
	Wallpapers) source "$SMOKIES/wallpapers.sh" ;;

	Alacritty*) source "$SMOKIES/gnome-terminal.sh" ;;
	Mimetypes) source "$SMOKIES/mimetypes.sh" ;;
	Configs) source "$SMOKIES/configs.sh" ;;
	SDDM*) source "$SMOKIES/sddm-theme.sh" ;;
	*) echo "Unrecognised installation instruction $selected! Exiting." && exit 1 ;;
	esac
done

source "$SMOKIES/migrations.sh" --set-done

gum style --bold --foreground="#55FF99" "Installation completed successfully!"
gum style --underline "It is recommended to reboot after installation."
if gum confirm --show-help=false --affirmative "Reboot Now" --negative "" ""; then
	systemctl reboot --no-wall
else
	source "$SMOKIESH/show-done.sh"
fi
