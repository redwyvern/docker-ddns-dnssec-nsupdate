#!/bin/bash

# The URL to use to return the IP (can be any kind of "what's my IP" like site)
export IP_URL="http://icanhazip.com/"
# Regular expression to retrieve the IP from the website. This just grabs the first thing it sees that looks like an IP address and so it should work for most sites.
export IP_CHECK_REGEX="[^0-9]*\([[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\.[[:digit:]]\{1,3\}\).*"
# The amount of time to wait when connecting to the website before retrying
export IP_URL_TIMEOUT=5
# How long to wait after checking the IP address
export INTERVAL=300

######################## DNS Record Information #####################
# DNS server name
export SERVER_NAME=ns1.example.com
# The domain name of the record to update
export DOMAIN_NAME=dyndom.example.org
# The host name of the record to update
export HOST_NAME=home-example
# The TTL to set for the record, this should normally at least be no more than a day (86400)
export RECORD_TTL=3600
#####################################################################

########## The HMAC-MD5 key used to update the DNS server ###########
# This key can be generated via the command "dnssec-keygen -r /dev/urandom -a HMAC-MD5 -b 512 -n HOST my_key_name" where 'my_key_name' is the name of the key (this is arbitrary however the name must also be used in the 'KEY_NAME' setting below).
# Note that only the "private" file that gets generated from this command is needed. You should retrieve the required information from this file. This same information should then be used to set up the DNS server end.

export KEY_NAME="example-key"
export KEY_SECRET="Secret goes here"
#####################################################################


############# Logging and Escalation Information ####################

# Tag to use when logging to syslog
export LOGGER_TAG="ddns-script"

# How long to wait before sending a warning e-mail when the IP address cannot be updated due to either the IP check website being unreachable or due to the DNS update not working. Note that the warning e-mail will be resent every ESCALATE_AFTER seconds and so a low value may lead to a lot of e-mail spam if the update is not successful for a long period of time.
export ESCALATE_AFTER=3600

# E-mail address of the recipient of the escalation
export ESCALATE_TO=myemail@example.mail.com
# The from address of the escalation e-mail
export ESCALATE_FROM=ddns-updater@my.home.domain.com
# The subject of the escalation e-mail (note that additional information gets suffixed to the subject)
export ESCALATE_SUBJECT="DDNS Script Notification"
# The SMTP server to use (assumes basic SMTP, no TLS or authentication etc)
export SMTP_SERVER="smtp-server:25"
# Whether to send an e-mail when the IP address is successfully updated. 
# Note that the IP address is only actually updated when it changes.
export MAIL_ON_SUCCESS=true
#####################################################################

############### Docker Container Settings ###########################
NAME='ddns'
# This should be a network that has the 'smtp-server' alias on it.
NETWORK_NAME=dev_nw
CONTAINER_HOST_NAME='ddns-updater'
#####################################################################

docker stop "${NAME}" 2>/dev/null && sleep 1
docker rm "${NAME}" 2>/dev/null && sleep 1
docker run --detach=true --restart=always --name "${NAME}" --hostname "${CONTAINER_HOST_NAME}" \
    --env IP_URL \
    --env IP_CHECK_REGEX \
    --env IP_URL_TIMEOUT \
    --env INTERVAL \
    --env SERVER_NAME \
    --env DOMAIN_NAME \
    --env HOST_NAME \
    --env RECORD_TTL \
    --env KEY_NAME \
    --env KEY_SECRET \
    --env LOGGER_TAG \
    --env ESCALATE_AFTER \
    --env ESCALATE_TO \
    --env ESCALATE_FROM \
    --env ESCALATE_SUBJECT \
    --env SMTP_SERVER \
    --env MAIL_ON_SUCCESS \
    --network=${NETWORK_NAME} \
    redwyvern/ddns-dnssec-nsupdate

