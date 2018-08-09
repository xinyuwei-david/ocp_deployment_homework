#!/usr/bin/sh


echo  "==================Stage 3.1: Create Users and Group================="
ansible masters -m shell -a 'htpasswd -cb /etc/origin/master/htpasswd david david' 
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd wei wei'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd hedy hedy'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd deng deng'
oc adm policy add-cluster-role-to-user cluster-admin admin
oc adm groups new dev  david wei
oc adm groups new test hedy deng

echo  "==========Stage 3.2: Config ResourceQuota For Special Users========"

for OCP_USERNAME in david wei hedy deng; do

oc create clusterquota clusterquota-$OCP_USERNAME \
 --project-annotation-selector=openshift.io/requester=$OCP_USERNAME \
 --hard pods=25 \
 --hard requests.memory=6Gi \
 --hard requests.cpu=5 \
 --hard limits.cpu=25  \
 --hard limits.memory=40Gi \
 --hard configmaps=25 \
 --hard persistentvolumeclaims=25  \
 --hard services=25

done

echo  "=========Stage 3.3: Customize Project Template With LimitRange====================="
oc create -f ./resources/template.yaml


ansible masters -m shell -a "sed -i 's/projectRequestTemplate.*/projectRequestTemplate\: \"default\/project-request\"/g' /etc/origin/master/master-config.yaml"

ansible masters -m shell -a'systemctl restart atomic-openshift-master-api'
ansible masters -m shell -a'systemctl restart atomic-openshift-master-controllers'
