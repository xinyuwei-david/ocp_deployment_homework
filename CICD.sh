#!/usr/bin/sh
PWD=`pwd`
ansible-playbook -i $PWD/resources/container-pipelines/basic-spring-boot/applier/inventory/ $PWD/resources/openshift-applier/playbooks/openshift-cluster-seed.yml
oc autoscale dc/spring-rest --min=1 --max=10 --cpu-percent=80 -n basic-spring-boot-prod
