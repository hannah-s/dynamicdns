#!/bin/bash

# What's the hostname you want tied to your dynamic IP address?
# Mine is:

MYHOSTNAME="home.parabiosis.net"

ZONEID=$(aws route53 list-hosted-zones | grep '"Id":' | awk -F "/" '{print $3}' | tr -d '",')
NEWIP=$(dig +short myip.opendns.com @resolver1.opendns.com)
CURRENTIP=$(dig $MYHOSTNAME +short)
CHANGETIME=$(date +%Y-%m-%d:%H:%M:%S)

echo "Current DNS record: $CURRENTIP."


if [ ! -s ~/.aws/config ] ; then
	echo "You need to configure awscli first."
	echo "See http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html for info."
	exit 1
fi

## Making sure we have an actual external IP before proceeding.
## There are other ways to validate an IP. In an ideal world,
## I'd be verifying that it's not a private one too.

if [ ! -z $(ipcalc -c $NEWIP | grep INVALID ) ] ; then
	echo "No new valid IP address: $NEWIP. Exiting."
exit 1
fi


## Checking IP and updating DNS, if needed.

if [ $NEWIP != $CURRENTIP ] ; then
	echo "The external IP address has changed to $NEWIP." 
	echo "Updating the A record for $MYHOSTNAME."
	sed "s/MYHOSTNAME/$MYHOSTNAME/g; s/CHANGETIME/$CHANGETIME/g; s/NEWIP/$NEWIP/g" ~/dynamicdns/template.json > /tmp/$MYHOSTNAME.json 
	aws route53 change-resource-record-sets --hosted-zone-id $ZONEID --change-batch file:///tmp/$MYHOSTNAME.json 
		
		if [ $? = 0 ] ; then
			echo "Done."
		else
			echo "Fail."
		fi

else
	echo "The external IP address remains unchanged"
fi

