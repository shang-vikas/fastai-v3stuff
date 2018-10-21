#! /bin/bash

if [ "$EUID" -ne 0 ];then 
	echo "Please run with root privileges"
	exit
fi
GREEN='\033[0;32m'
NC='\033[0m' # No Color

script=""
script1=./starter-1.sh
script2=./starter-2.sh

externaldisk=""
disksize=""
function createdisk() {
	echo -e "$GREEN creating a new external disk.. Type in the name of disks $NC"
	read externaldisk
	echo -e "Type in the size of disk in GB, recommended=200. Note you can always increase the size later."
	read disksize
	gcloud compute disks create $externaldisk --size $disksize --zone $zoneid
}

function check_package() {
	var=$(which $1)
	if [ "$var" != "" ];then
		return 0
	else
		return 1
	fi
}

function cElement() {
	  local e match="$1"
	    shift
	      for e; do [[ "$e" == "$match" ]] && return 0; done
	        return 1
}
lst=('yes' 'Yes' 'YES' 'No' 'no' 'NO')
function authenticate() {
	while true;do
		echo -ne "$GREEN Do you want to authenticate your GCP account? This is for first timers or those who mess up their configuration file..\n >>>>(yes/no) $NC"
		read response
		cElement $response ${lst[@]:0:3}
		cyes=$?
		cElement $response ${lst[@]:3}
		cno=$?
		if [ "$cyes" = "0" ] ;then
			echo -e "$GREEN Now please authenticate your GCP user account and choose reinitialize default config ,then choose us-west1-b(11 number) in region when asked $NC"
			echo -e "$GREEN Hit enter to continue..... $NC"
			read tmp
			gcloud init
			break
		elif [ "$cno" = "0" ];then
			break
		fi
	done
}

echo -e "$GREEN This process will setup the preemptible gpu instance with the necessary fastai v1 library and pytorch 1.0dev.......... $NC"
sleep 2


echo -e "$GREEN Checking pip3 and gcloud..... $NC"
tmp=$(check_package pip3)
if [ "$tmp" = "1" ]; then
	apt install python3-pip --yes
fi
tmp=$(check_package gcloud)
if [ "$tmp" = "1" ]; then
	pip3 install gcloud --user
fi

authenticate

zoneid=$(gcloud config list|grep zone|awk 'NF>1{print $NF}')
projectid=$(gcloud config list|grep project|awk 'NF>1{print $NF}')
diskcnt=$(gcloud compute disks list|wc -l)
echo -e "$GREEN $(($diskcnt -1)) disks found $NC"
if [ $(($diskcnt -1)) -ne 0 ]; then
	echo -e $GREEN Choose from existing disks or enter 0 to create new one. $NC
	echo -e  $(gcloud compute disks list|grep -v NAME|awk '{print"[" NR "]" ":" $0 "\\n"}')
	read labelno
	if [ $labelno -gt $diskcnt ];then
		echo -e $GREEN wrong number chosen.exiting.. $NC
		exit
	elif [ $labelno -eq 0 ];then
		createdisk
		script=$script2

	else
		externaldisk=$(gcloud compute disks list|awk '{if(NR=='$(($labelno + 1))') print $1;}')
		script=$script1
	fi
else
	createdisk
	script=$script2
fi


echo -e "using defaults -- zone $zoneid, project $projectid"
#time to create gpu_instance preemptible
accountid=$(gcloud iam service-accounts list |grep "Compute Engine"|awk 'NF>1{print $NF}')
echo -e "$GREEN Enter the name of the instance,num-of-cores,ram-size(GB),type-of-gpu(k80,p100,v100),count(1,2,4) \n example:gpu-ins 4 16 k80 1 $NC"
read iname cores ram typegpu countt
echo -e "$GREEN Sit back and relax, This may take a while.. You can monitor the progress on Google cloud console $NC"
gcloud beta compute --project=$projectid instances create $iname --zone=$zoneid --machine-type=custom-$cores-$(($ram*1024)) --subnet=default --network-tier=PREMIUM --metadata-from-file=startup-script="$script" --no-restart-on-failure --maintenance-policy=TERMINATE --preemptible --service-account=$accountid --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --accelerator=type=nvidia-tesla-$typegpu,count=$countt --tags=http-server,https-server --image=fastai-image-v3 --image-project=fastai-v1-219409 --boot-disk-size=60GB --boot-disk-type=pd-standard --boot-disk-device-name=$instancename --disk=name=$externaldisk,device-name=$externaldisk,mode=rw,boot=no




