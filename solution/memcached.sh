#!/bin/sh

JSON=`cat template.json`

METRICS=(uptime curr_connections listen_disabled_num conn_yields cmd_get cmd_set cmd_flush bytes_read bytes_written get_hits evictions limit_maxbytes)

for metric in ${METRICS[*]}
do
  KEY=$(memcached-tool $MEMCACHED_HOST:$MEMCACHED_PORT stats | grep $metric | awk '{print $1}' | tr -d ' ')
  VALUE=$(memcached-tool $MEMCACHED_HOST:$MEMCACHED_PORT stats | grep $metric | awk '{print $2}' | tr -d ' ')
  JSON=`echo ${JSON} | sed -e "s@$KEY@$VALUE@"`
done

# Remove all the whitespace from the JSON
JSON=`echo ${JSON} | tr -d ' \t\n\r\f'`

# Print the result
echo "${JSON}"
