# PRTG2Pachka

This is a fork of the original to fix some issues (e.g. JSON SSL, ordered hash to to generate JSON) and add some extras.
This repository contains a PowerShell script (prtg2pchk.ps1) that can be used with PRTG Network Monitor to send a JSON-formatted alert payload to a Pachka messenger (Пачка).


## Test Environment

This PowerShell script has been tested with the following configuration:
* Windows Server 2016 Standard
* PowerShell v5.x or higher
* PRTG v26.1


## Installation

Copy the PowerShell script to the following directory on the PRTG server:

`C:\Program Files (x86)\PRTG Network Monitor\Notifications\EXE`

The script is designed to send events to Pachka.  Modify the script adding the appropriate Pachka webhook URL.

The script is called via a new Notification Template (see Setup | Account Settings | Notification Templates).


![Image 1: Creating a new Notification Template in PRTG](./images/Image1-Notification-Template.png)


Then select the 'Execute Program' method and select the corresponding PowerShell script for creating Pachka notification.


![Image 2: Select and configure the Execture Program method in PRTG](./images/Image2-Execute-Program-Method.png)


Specify the parameters PRTG should send to the PowerShell script.  The script expects the following parameters in the exact order:

`'%probe' '%device' '%sensor' '%group' '%home' '%host' '%status' '%colorofstate' '%down' '%priority' '%message' '%datetime'`

Then create a Notification Trigger.  This can be done in one of two ways:


![Image 3: Configure the Notification Triggers in PRTG](./images/Image3-Notification-Triggers.png)


1. Create a new Library and drag the desired devices into the Library and then create the Notification Trigger at this level.
1. Create the Notification Trigger at the Root level.



