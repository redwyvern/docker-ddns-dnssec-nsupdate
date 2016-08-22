![](https://img.shields.io/docker/stars/redwyvern/ddns-dnssec-nsupdate.svg)
![](https://img.shields.io/docker/pulls/redwyvern/ddns-dnssec-nsupdate.svg)
![](https://img.shields.io/docker/automated/redwyvern/ddns-dnssec-nsupdate.svg)
[![](https://images.microbadger.com/badges/image/redwyvern/ddns-dnssec-nsupdate.svg)](https://microbadger.com/images/redwyvern/ddns-dnssec-nsupdate "Get your own image badge on microbadger.com")

An image running a DDNS update daemon that will continually update the configured DNS server as the host's public IP changes.

An update key (normally generated via dnssec-keygen) is used to securely update the configured DNS server. The daemon obtains the
public IP of the host by using a 'what's my IP?' type website.

The daemon will only updated the DNS server when it sees a change of IP or when it first starts. It can also optionally send an
e-mail when a new address is set. Additionally, the daemon will escalate a warning via e-mail if after a configurable period
of time, the daemon is either unable to obtain the current IP or unable to update the DNS server with a new IP.

The image assumes that you will connect it to a network that has the host name (configurable) smtp-server, which it will use to
send e-mails.

The daemon itself can be configured through the provided 'run.sh' script which you should use as a startup script to launch the container.
The script contains various documented settings that allow you to configure the DDNS update daemon.

The easiest way to debug is to exec a bash session inside the container and then look at /var/log/syslog.

The script will output information to this log.
