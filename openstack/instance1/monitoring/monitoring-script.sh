#!/usr/bin/env bash





SESSION_USERNAME_SCRIPT=tcc-computer3
SESSION_GROUP_SCRIPT=tcc-computer3



LOG_DIRECTORY=logs
CPU_LOG_DIRECTORY=cpu_monitoring
RAM_MEMORY_LOG_DIRECTORY=ram_memory_monitoring
NETWORK_TRAFFIC_LOG_DIRECTORY=network_traffic_monitoring



MONITORING_INTERVAL=1
MONITORING_COUNT=1728000
MONITORING_TITLE_LINES=3
CPU_LOG_NAME=cpu_monitoring_log
RAM_MEMORY_LOG_NAME=ram_memory_monitoring



NETWORK_INTERFACE=ens3
HTTP_PORT=80
HTTPS_PORT=443
BACKEND_PORT=3000
FRONTEND_PORT=4000



HOST_IP=10.0.0.45
NETWORK_TRAFFIC_LOG_NAME=network_traffic_monitoring
NETWORK_TRAFFIC_COUNT=1728000





cpu_monitoring()
{

	cd ${LOG_DIRECTORY}
	
	if [ ! -d "${CPU_LOG_DIRECTORY}" ];
	then
		
		mkdir ${CPU_LOG_DIRECTORY}
		sudo chmod 0775 ${CPU_LOG_DIRECTORY}
		sudo chown "${SESSION_USERNAME_SCRIPT}":"${SESSION_GROUP_SCRIPT}" ${CPU_LOG_DIRECTORY}
		
	fi;
	
	cd ${CPU_LOG_DIRECTORY}

	CPU_LOG_FILE="${CPU_LOG_NAME}"_"$(date "+%H%M%S%d%m%y")".log""

	if [ ! -d "${CPU_LOG_FILE}" ];
	then
	
		touch ${CPU_LOG_FILE}
		sudo chmod 0775 ${CPU_LOG_FILE}
		sudo chown "${SESSION_USERNAME_SCRIPT}":"${SESSION_GROUP_SCRIPT}" ${CPU_LOG_FILE}
	
	fi;
	
	sar -u ${MONITORING_INTERVAL} ${MONITORING_COUNT} | cat -n | while read line register; 
	do

		if [ ${line} -lt ${MONITORING_TITLE_LINES} ] || [ ${line} = ${MONITORING_TITLE_LINES} ];
		then
			continue
		fi;
		
		echo ${register} | \
		awk '{$1=$1;}1' | awk '{print $1, $3, $5, $6, $8}' >> ${CPU_LOG_FILE}
	
	done;
	
	cd ..
	cd ..

}

ram_memory_monitoring()
{

	cd ${LOG_DIRECTORY}
	
	if [ ! -d "${RAM_MEMORY_LOG_DIRECTORY}" ];
	then
		
		mkdir ${RAM_MEMORY_LOG_DIRECTORY}
		sudo chmod 0775 ${RAM_MEMORY_LOG_DIRECTORY}
		sudo chown "${SESSION_USERNAME_SCRIPT}":"${SESSION_GROUP_SCRIPT}" ${RAM_MEMORY_LOG_DIRECTORY}
		
	fi;
	
	cd ${RAM_MEMORY_LOG_DIRECTORY}

	RAM_MEMORY_LOG_FILE="${RAM_MEMORY_LOG_NAME}"_"$(date "+%H%M%S%d%m%y")".log""

	if [ ! -d "${RAM_MEMORY_LOG_FILE}" ];
	then
	
		touch ${RAM_MEMORY_LOG_FILE}
		sudo chmod 0775 ${RAM_MEMORY_LOG_FILE}
		sudo chown "${SESSION_USERNAME_SCRIPT}":"${SESSION_GROUP_SCRIPT}" ${RAM_MEMORY_LOG_FILE}
	
	fi;

	sar -r ${MONITORING_INTERVAL} ${MONITORING_COUNT} | cat -n | while read line register; 
	do
	
		if [ ${line} -lt ${MONITORING_TITLE_LINES} ] || [ ${line} = ${MONITORING_TITLE_LINES} ]; 
		then
			continue
		fi;
		
		echo ${register} | \
		awk '{$1=$1;}1' | awk '{print $1, $3, $4, $5, $8, $9}' >> ${RAM_MEMORY_LOG_FILE}
	
	done;
	
	cd ..
	cd ..

}

network_traffic_monitoring()
{

	cd ${LOG_DIRECTORY}
	
	if [ ! -d "${NETWORK_TRAFFIC_LOG_DIRECTORY}" ];
	then
		
		mkdir ${NETWORK_TRAFFIC_LOG_DIRECTORY}
		sudo chmod 0775 ${NETWORK_TRAFFIC_LOG_DIRECTORY}
		sudo chown "${SESSION_USERNAME_SCRIPT}":"${SESSION_GROUP_SCRIPT}" ${NETWORK_TRAFFIC_LOG_DIRECTORY}
		
	fi;
	
	cd ${NETWORK_TRAFFIC_LOG_DIRECTORY}

	NETWORK_TRAFFIC_LOG_FILE="${NETWORK_TRAFFIC_LOG_NAME}"_"$(date "+%H%M%S%d%m%y")".log""

	if [ ! -d "${NETWORK_TRAFFIC_LOG_FILE}" ];
	then
	
		touch ${NETWORK_TRAFFIC_LOG_FILE}
		sudo chmod 0775 ${NETWORK_TRAFFIC_LOG_FILE}
		sudo chown "${SESSION_USERNAME_SCRIPT}":"${SESSION_GROUP_SCRIPT}" ${NETWORK_TRAFFIC_LOG_FILE}
		
	fi;

	sudo timeout ${NETWORK_TRAFFIC_COUNT} \
		tcpdump -l -n -i ${NETWORK_INTERFACE} ip and \
		port ${HTTP_PORT} or port ${HTTPS_PORT} or \
		port ${BACKEND_PORT} or port ${FRONTEND_PORT} and \
		src ${HOST_IP} or dst ${HOST_IP} and \
		tcp and 'tcp[tcpflags] & tcp-push != 0' and 'tcp[13] != 2' and\
		not 'tcp[tcpflags] & (tcp-syn|tcp-fin|tcp-rst) != 0' and \
		not broadcast and not multicast and \
		greater 0 and less 1024000000 >> ${NETWORK_TRAFFIC_LOG_FILE}
		
	cd ..
	cd ..

}

if [ ! -d "${LOG_DIRECTORY}" ];
then
	
	mkdir ${LOG_DIRECTORY}
	sudo chmod 0775 ${LOG_DIRECTORY}
	sudo chown "${SESSION_USERNAME_SCRIPT}":"${SESSION_GROUP_SCRIPT}" ${LOG_DIRECTORY}
	
fi;





cpu_monitoring &
ram_memory_monitoring &
network_traffic_monitoring &





