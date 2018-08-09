#!/usr/bin/sh

PWD=`pwd`

echo  '=========Stage1: Update ansible hosts==========='
echo -n "Please input the GUID : "
read ANS
echo "export GUID=$GUID" >>$HOME/.bashrc
>/etc/ansible/hosts

cat << EOF > /etc/ansible/hosts
[OSEv3:vars]

###########################################################################
### Ansible Vars
###########################################################################
timeout=60
ansible_become=yes
ansible_ssh_user=ec2-user

###########################################################################
### OpenShift Basic Vars
###########################################################################
deployment_type=openshift-enterprise
containerized=false
openshift_disable_check="memory_availability"

# Default node selectors
osm_default_node_selector='env=app'
openshift_hosted_infra_selector="env=infra"

###########################################################################
### OpenShift Master Vars
###########################################################################

openshift_master_api_port=443
openshift_master_console_port=443

openshift_master_cluster_method=native
openshift_master_cluster_hostname=loadbalancer1.$ANS.internal
openshift_master_cluster_public_hostname=loadbalancer1.$ANS.example.opentlc.com
openshift_master_default_subdomain=apps.$ANS.example.opentlc.com
#openshift_master_ca_certificate={'certfile': '/root/intermediate_ca.crt', 'keyfile': '/root/intermediate_ca.key'}
openshift_master_overwrite_named_certificates=True

# Set this line to enable NFS
openshift_enable_unsupported_configurations=True

###########################################################################
### OpenShift Network Vars
###########################################################################

#osm_cluster_network_cidr=10.1.0.0/16
#openshift_portal_net=172.30.0.0/16

os_sdn_network_plugin_name='redhat/openshift-ovs-multitenant'
#os_sdn_network_plugin_name='redhat/openshift-ovs-subnet'

###########################################################################
### OpenShift Authentication Vars
###########################################################################

# htpasswd Authentication
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]
openshift_master_htpasswd_file=/root/htpasswd.openshift

# LDAP Authentication (download ipa-ca.crt first)
# openshift_master_identity_providers=[{'name': 'ldap', 'challenge': 'true', 'login': 'true', 'kind': 'LDAPPasswordIdentityProvider','attributes': {'id': ['dn'], 'email': ['mail'], 'name': ['cn'], 'preferredUsername': ['uid']}, 'bindDN': 'uid=admin,cn=users,cn=accounts,dc=shared,dc=example,dc=opentlc,dc=com', 'bindPassword': 'r3dh4t1!', 'ca': '/etc/origin/master/ipa-ca.crt','insecure': 'false', 'url': 'ldaps://ipa.shared.example.opentlc.com:636/cn=users,cn=accounts,dc=shared,dc=example,dc=opentlc,dc=com?uid?sub?(memberOf=cn=ocp-users,cn=groups,cn=accounts,dc=shared,dc=example,dc=opentlc,dc=com)'}]
# openshift_master_ldap_ca_file=/root/ipa-ca.crt

###########################################################################
### OpenShift Router and Registry Vars
###########################################################################

openshift_hosted_router_replicas=2
# openshift_hosted_router_certificate={"certfile": "/path/to/router.crt", "keyfile": "/path/to/router.key", "cafile": "/path/to/router-ca.crt"}

openshift_hosted_registry_replicas=1

openshift_hosted_registry_storage_kind=nfs
openshift_hosted_registry_storage_access_modes=['ReadWriteMany']
openshift_hosted_registry_storage_nfs_directory=/srv/nfs
openshift_hosted_registry_storage_nfs_options='*(rw,root_squash)'
openshift_hosted_registry_storage_volume_name=registry
openshift_hosted_registry_storage_volume_size=20Gi
openshift_hosted_registry_pullthrough=true
openshift_hosted_registry_acceptschema2=true
openshift_hosted_registry_enforcequota=true

###########################################################################
### OpenShift Service Catalog Vars
###########################################################################

openshift_enable_service_catalog=true

template_service_broker_install=true
openshift_template_service_broker_namespaces=['openshift']

ansible_service_broker_install=true
ansible_service_broker_local_registry_whitelist=['.*-apb$']

openshift_hosted_etcd_storage_kind=nfs
openshift_hosted_etcd_storage_nfs_options="*(rw,root_squash,sync,no_wdelay)"
openshift_hosted_etcd_storage_nfs_directory=/srv/nfs
openshift_hosted_etcd_storage_labels={'storage': 'etcd-asb'}
openshift_hosted_etcd_storage_volume_name=etcd-asb
openshift_hosted_etcd_storage_access_modes=['ReadWriteOnce']
openshift_hosted_etcd_storage_volume_size=10G

###########################################################################
### OpenShift Metrics and Logging Vars
###########################################################################

# Enable cluster metrics
openshift_metrics_install_metrics=True

openshift_metrics_storage_kind=nfs
openshift_metrics_storage_access_modes=['ReadWriteOnce']
openshift_metrics_storage_nfs_directory=/srv/nfs
openshift_metrics_storage_nfs_options='*(rw,root_squash)'
openshift_metrics_storage_volume_name=metrics
openshift_metrics_storage_volume_size=10Gi
openshift_metrics_storage_labels={'storage': 'metrics'}

openshift_metrics_cassandra_nodeselector={"env":"infra"}
openshift_metrics_hawkular_nodeselector={"env":"infra"}
openshift_metrics_heapster_nodeselector={"env":"infra"}

# Enable cluster logging
openshift_logging_install_logging=True

openshift_logging_storage_kind=nfs
openshift_logging_storage_access_modes=['ReadWriteOnce']
openshift_logging_storage_nfs_directory=/srv/nfs
openshift_logging_storage_nfs_options='*(rw,root_squash)'
openshift_logging_storage_volume_name=logging
openshift_logging_storage_volume_size=10Gi
openshift_logging_storage_labels={'storage': 'logging'}

# openshift_logging_kibana_hostname=kibana.apps.$ANS.example.opentlc.com
openshift_logging_es_cluster_size=1

openshift_logging_es_nodeselector={"env":"infra"}
openshift_logging_kibana_nodeselector={"env":"infra"}
openshift_logging_curator_nodeselector={"env":"infra"}

###########################################################################
### OpenShift Prometheus Vars
###########################################################################

## Add Prometheus Metrics:
openshift_hosted_prometheus_deploy=true
openshift_prometheus_node_selector={"env":"infra"}
openshift_prometheus_namespace=openshift-metrics

# Prometheus
openshift_prometheus_storage_kind=nfs
openshift_prometheus_storage_access_modes=['ReadWriteOnce']
openshift_prometheus_storage_nfs_directory=/srv/nfs
openshift_prometheus_storage_nfs_options='*(rw,root_squash)'
openshift_prometheus_storage_volume_name=prometheus
openshift_prometheus_storage_volume_size=10Gi
openshift_prometheus_storage_labels={'storage': 'prometheus'}
openshift_prometheus_storage_type='pvc'
# For prometheus-alertmanager
openshift_prometheus_alertmanager_storage_kind=nfs
openshift_prometheus_alertmanager_storage_access_modes=['ReadWriteOnce']
openshift_prometheus_alertmanager_storage_nfs_directory=/srv/nfs
openshift_prometheus_alertmanager_storage_nfs_options='*(rw,root_squash)'
openshift_prometheus_alertmanager_storage_volume_name=prometheus-alertmanager
openshift_prometheus_alertmanager_storage_volume_size=10Gi
openshift_prometheus_alertmanager_storage_labels={'storage': 'prometheus-alertmanager'}
openshift_prometheus_alertmanager_storage_type='pvc'
# For prometheus-alertbuffer
openshift_prometheus_alertbuffer_storage_kind=nfs
openshift_prometheus_alertbuffer_storage_access_modes=['ReadWriteOnce']
openshift_prometheus_alertbuffer_storage_nfs_directory=/srv/nfs
openshift_prometheus_alertbuffer_storage_nfs_options='*(rw,root_squash)'
openshift_prometheus_alertbuffer_storage_volume_name=prometheus-alertbuffer
openshift_prometheus_alertbuffer_storage_volume_size=10Gi
openshift_prometheus_alertbuffer_storage_labels={'storage': 'prometheus-alertbuffer'}
openshift_prometheus_alertbuffer_storage_type='pvc'

# Necessary because of a bug in the installer on 3.9
openshift_prometheus_node_exporter_image_version=v3.9

###########################################################################
### OpenShift Hosts
###########################################################################
[OSEv3:children]
lb
masters
etcd
nodes
nfs
#glusterfs

[lb]
loadbalancer1.$ANS.internal

[masters]
master1.$ANS.internal
master2.$ANS.internal
master3.$ANS.internal

[etcd]
master1.$ANS.internal
master2.$ANS.internal
master3.$ANS.internal

[nodes]
## These are the masters
master1.$ANS.internal openshift_hostname=master1.$ANS.internal openshift_node_labels="{'env':'master', 'cluster': '$ANS'}"
master2.$ANS.internal openshift_hostname=master2.$ANS.internal openshift_node_labels="{'env':'master', 'cluster': '$ANS'}"
master3.$ANS.internal openshift_hostname=master3.$ANS.internal openshift_node_labels="{'env':'master', 'cluster': '$ANS'}"

## These are infranodes
infranode1.$ANS.internal openshift_hostname=infranode1.$ANS.internal  openshift_node_labels="{'env':'infra', 'cluster': '$ANS'}"
infranode2.$ANS.internal openshift_hostname=infranode2.$ANS.internal  openshift_node_labels="{'env':'infra', 'cluster': '$ANS'}"

## These are regular nodes
node1.$ANS.internal openshift_hostname=node1.$ANS.internal  openshift_node_labels="{'env':'app', 'cluster': '$ANS'}"
node2.$ANS.internal openshift_hostname=node2.$ANS.internal  openshift_node_labels="{'env':'app', 'cluster': '$ANS'}"
node3.$ANS.internal openshift_hostname=node3.$ANS.internal  openshift_node_labels="{'env':'app', 'cluster': '$ANS'}"

## These are CNS nodes
# support1.$ANS.internal openshift_hostname=support1.$ANS.internal  openshift_node_labels="{'env':'glusterfs', 'cluster': '$ANS'}"
# support2.$ANS.internal openshift_hostname=support2.$ANS.internal  openshift_node_labels="{'env':'glusterfs', 'cluster': '$ANS'}"
# support3.$ANS.internal openshift_hostname=support3.$ANS.internal  openshift_node_labels="{'env':'glusterfs', 'cluster': '$ANS'}"

[nfs]
support1.$ANS.internal openshift_hostname=support1.$ANS.internal
EOF






echo  '====================Stage2: Update ansible hosts==========================='

ansible all -m ping

echo  '==================Stage2.1: Begin to do pre-requisites===================='
ansible-playbook -f 20 /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml

echo '=====================Finish to do pre-requisites======================='

echo  '====================Stage2.2: Begin to Install Openshift================='
ansible-playbook -f 20 /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
echo 'Finish to Install Openshift'

echo  '====================Stage3: Begin to do post-install======================='

ansible support1.$ANZ.internal -m copy -a 'src=./scripts/pv.sh dest=~/pv.sh owner=root group=root mode=0744'

ansible support1.$ANZ.internal -m shell -a '~/pv.sh'

ansible masters[0] -b -m fetch -a "src=/root/.kube/config dest=/root/.kube/config flat=yes"

chmod +x $PWD/scripts/pvs.sh

$PWD/scripts/pvs.sh

cat /root/pvs/* | oc create -f -

# check pv list
oc get pv

# Fix NFS Persistent Volume Recycling
ansible nodes -m shell -a "docker pull registry.access.redhat.com/openshift3/ose-recycler:latest"
ansible nodes -m shell -a "docker tag registry.access.redhat.com/openshift3/ose-recycler:latest registry.access.redhat.com/openshift3/ose-recycler:v3.9.30"

echo '====================================Finish to post-install====================================='
