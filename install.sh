#!/bin/bash
# If the installer fails, change #!/bin/bash to #!/bin/sh

. ./install.config
SCRIPTDIR='~/infra-memcached/solution'

printf "Installing $INTEGRATION_NAME Extension...\n"

DEFINITION_PATH="/var/db/newrelic-infra/custom-integrations"
CONFIG_PATH="/etc/newrelic-infra/integrations.d"
SERVICE='newrelic-infra'

#check os release
if [ -f /etc/os-release ]; then #amazon/redhat/fedora check
  . /etc/os-release
  OS=$NAME
  VERSION=$VERSION_ID
  printf "OS Name: $OS\n"
  printf "Version: $VERSION\n"
elif [ -f /etc/lsb-release ]; then #ubuntu/debian check
  . /etc/lsb-release
  OS=$DISTRIB_ID
  VERSION=$DISTRIB_RELEASE
  printf "OS Name: $OS\n"
  printf "Version: $VERSION\n"
fi

#check init system
if [[ ${VERSION:0:1} == "7" || "8" ]] || [[ ${VERSION:0:2} == "15" ]]; then
  if [[ `systemctl` =~ -\.mount ]]; then #systemd
    SYSCMD='systemd'
  fi
elif [[ ${VERSION:0:1} == "6" ]] || [[ $OS == *Amazon* ]] || [[ ${VERSION:0:2} == "14" ]]; then
  if [[ `/sbin/init --version` =~ upstart ]]; then #upstart
    SYSCMD='upstart'
  fi
fi

#copy files
printf "Copying files...\n"

[ -d $DEFINITION_PATH/$INTEGRATION_NAME ] || mkdir -p $DEFINITION_PATH/$INTEGRATION_NAME
if [[ $OS_SPECIFIC_DEFINITIONS == "true" ]]; then
  cp $SCRIPTDIR/$INTEGRATION_NAME-definition-linux.yml $DEFINITION_PATH/$INTEGRATION_NAME-definition.yml
else
  cp $SCRIPTDIR/$INTEGRATION_NAME-definition.yml $DEFINITION_PATH
fi
cp $SCRIPTDIR/$EXECUTABLE_NAME $DEFINITION_PATH/$INTEGRATION_NAME
cp $SCRIPTDIR/$TEMPLATE_NAME $DEFINITION_PATH/$INTEGRATION_NAME
if [[ $OS_SPECIFIC_CONFIGS == "true" ]]; then
  cp $SCRIPTDIR/$INTEGRATION_NAME-config-linux.yml $CONFIG_PATH/$INTEGRATION_NAME-config.yml
else
  cp $SCRIPTDIR/$INTEGRATION_NAME-config.yml $CONFIG_PATH
fi

#restart agent
printf "Script complete. Restarting Infrastructure Agent...\n"
if [ $SYSCMD == 'systemd' ]; then
  systemctl restart $SERVICE
elif [ $SYSCMD == 'upstart' ]; then
  initctl restart $SERVICE
fi
