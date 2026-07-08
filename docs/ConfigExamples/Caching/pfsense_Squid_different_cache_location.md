---
categories: [ConfigExample]
FaqSection: operation
---
## Dscription
This script creates a filesystem overlay using nullfs to mount an alternate NVMe-backed directory as the Squid cache location. On pfSense systems, the standard cache path (/var/squid/cache) is transparently redirected to a user-defined path on a different drive.
The overlay itself functions correctly: Squid writes to and utilizes the new cache location as intended. However, the Clear Cache button in the pfSense GUI does not currently work with this setup. While this was the original goal of the project, this implementation is an important first step—it enables cache relocation without modifying Squid’s configured path, even though cache clearing still requires manual intervention.
—
J. Lee
## Usage
This script is intended for Netgate pfSense systems where Squid’s cache is normally located at:
		/var/squid/cache
When an alternate drive or filesystem (such as NVMe storage) is used for caching, management becomes more complex. In particular, the pfSense Clear Cache function does not operate correctly, requiring manual deletion of cache files.
This script was created to simplify cache relocation by overlaying the default Squid cache path with a different storage location, while maintaining compatibility with pfSense’s expected directory structure.

## Add the cron file
		@reboot /root/mount_squid_nullfs.sh
or what ever path you use to the script file also it must be made execuateable. 
## Script .sh file used for cron job

		#!/bin/sh
		
		TAG="squid-nullfs"
		NVME_DEV="/dev/nda0p2"
		NVME_MNT="/nvme/LOGS_Optane"
		CACHE_SRC="${NVME_MNT}/Squid_Cache"
		CACHE_DST="/var/squid/cache"
		
		# --- Helper function to log safely to system.log using pfSense PHP ---
		log_sys() {
		    MESSAGE="$1"
		    logger -t "$TAG" "$MESSAGE"
		}
		
		log_sys "Starting Squid nullfs mount sequence"
		
		# 1. Ensure NVMe filesystem is mounted
		if ! mount | grep -q "on ${NVME_MNT} "; then
		    log_sys "Mounting NVMe filesystem"
		    mount_msdosfs "${NVME_DEV}" "${NVME_MNT}" || {
		        log_sys "ERROR: NVMe mount failed"
		        exit 1
		    }
		else
		    log_sys "NVMe already mounted"
		fi
		
		# 2. Stop squid if running
		if pgrep -x squid >/dev/null; then
		    log_sys "Stopping squid"
		    /usr/local/sbin/pfSsh.php playback svc stop squid
		    sleep 2
		fi
		
		# 3. Ensure directories exist
		mkdir -p "${CACHE_SRC}" "${CACHE_DST}"
		
		# 4. Mount nullfs if not already mounted
		if ! mount | grep -q "on ${CACHE_DST} "; then
		    log_sys "Mounting nullfs cache"
		    mount -t nullfs "${CACHE_SRC}" "${CACHE_DST}" || {
		        log_sys "ERROR: nullfs mount failed"
		        exit 1
		    }
		else
		    log_sys "nullfs already mounted"
		fi
		
		# 5. Start squid
		log_sys "Starting squid"
		/usr/local/sbin/pfSsh.php playback svc start squid
		
		log_sys "Squid nullfs mount completed"
		
## Testing should show a valid mount on reboot in standard system logs 
		Squid nullfs mount completed
		Starting squid
		Mounting nullfs cache
		Mounting NVMe filesystem
		Starting Squid nullfs mount sequence
