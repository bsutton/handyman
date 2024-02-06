# We install this script in cron.d on production systems
# so that the IHAServer is restarted after a reboot.
# Start the server in the correct directory
cd /opt/handyman
# We use ihlaunch which will restart the iahserver if the iahserver crashes out.
/opt/handyman/bin/ihlaunch
