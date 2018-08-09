#!/usr/bin/bash
echo -n "Please input the project name you want to create, such as smoke-test : "
read ANS
oc login -u system:admin
oadm policy add-role-to-user cluster-admin admin
oc new-project  $ANS
oc new-app nodejs-mongo-persistent


sleep 100

curl http://nodejs-mongo-persistent-$ANS.apps.$GUID.example.opentlc.com | grep "Welcome to your Node.js application on OpenShift"

ret=`echo $?`
if [ "$ret" != "0" ]; then
    echo -e "=============Test is Failed===================================="\n
    exit 1
fi
echo -e "=================Smoke test is Passed!!!==========================="\n
