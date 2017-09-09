# Set-NetworkWatcher

This PowerShell script helps you enable Network Watcher[](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-monitoring-overview), easily across all the Network Security Groups in a certain region in your subscription. It will also configure Network Watcher to save the logs to a specific Storage Account. The three parameters that must be provided are:

1. Storage Account ID (-SAID parameter), is the Storage Account where you want to store the logging from Network Watcher.

2. Network Watcher ID (-NWID parameter), is the Network Watcher that you want to enable in the Network Security Groups.

3. Location (-Location parameter), is the location for which to enable Network Watcher.
