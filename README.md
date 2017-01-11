# dynamicdns

Automatic dynamic IP address A record updates to Route53 zones.
It's a pretty affordable option for dynamic DNSing.
I still need to write an actual README for this.

# Requirements

Must have: dnsutils (AKA bind-utils on some distros), [awscli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) installed and configured.

# To-do

* Add the TTL as a variable, rather than the 300 default I used.
* Check if the user has a ~/.aws/config configured. Return an error if not. 
