#!/bin/bash
ssh root@host01 'echo "Importing Red Hat Process Automation Manager 7 Image Streams into OpenShift." >> ~/script.log'
ssh root@host01 'for i in {1..200}; do oc create -f https://raw.githubusercontent.com/jboss-container-images/rhpam-7-openshift-image/7.1.0.GA/rhpam71-image-streams.yaml -n openshift && break || sleep 2; done'
ssh root@host01 'echo "Patching Image Streams." >> ~/script.log'
ssh root@host01 "for i in {1..200}; do oc patch is/rhpam71-businesscentral-openshift --type='json' -p '[{\"op\": \"replace\", \"path\": \"/spec/tags/0/from/name\", \"value\": \"registry.access.redhat.com/rhpam-7/rhpam71-businesscentral-openshift:1.0\"}]' -n openshift && break || sleep 2; done"
ssh root@host01 "for i in {1..200}; do oc patch is/rhpam71-kieserver-openshift --type='json' -p '[{\"op\": \"replace\", \"path\": \"/spec/tags/0/from/name\", \"value\": \"registry.access.redhat.com/rhpam-7/rhpam71-kieserver-openshift:1.0\"}]' -n openshift && break || sleep 2; done"
ssh root@host01 'echo "Importing Red Hat Process Automation Manager 7 - Trial template into OpenShift." >> ~/script.log'
ssh root@host01 'for i in {1..200}; do oc create -f https://raw.githubusercontent.com/jboss-container-images/rhpam-7-openshift-image/7.1.0.GA/templates/rhpam71-trial-ephemeral.yaml -n openshift && break || sleep 2; done'
ssh root@host01 'for i in {1..200}; do oc create -f https://raw.githubusercontent.com/openshift/origin/v3.7.0/examples/db-templates/postgresql-ephemeral-template.json -n openshift && break || sleep 2; done'
ssh root@host01 'echo "Logging into OpenShift as developer." >> ~/script.log'
ssh root@host01 'for i in {1..200}; do oc login localhost:8443 -u developer -p developer --insecure-skip-tls-verify=true && break || sleep 2; done'
ssh root@host01 'echo "Creating new demo project in OpenShift." >> ~/script.log'
ssh root@host01 'for i in {1..200}; do oc new-project ccd-project --display-name="Credit-Card-Dispute" --description="Red Hat Process Automation Manager 7 - Credit Card Dispute" && break || sleep 2; done'
ssh root@host01 'echo "Creating Business Central and KIE Server containers in OpenShift." >> ~/script.log'
ssh root@host01 'for i in {1..200}; do oc new-app --template=rhpam71-trial-ephemeral -p APPLICATION_NAME="ccd-project" -p IMAGE_STREAM_NAMESPACE="openshift" -p KIE_ADMIN_USER="developer" -p KIE_SERVER_CONTROLLER_USER="kieserver" -p KIE_SERVER_USER="kieserver" -p DEFAULT_PASSWORD="developer" -p MAVEN_REPO_USERNAME="developer" -p MAVEN_REPO_PASSWORD="developer" -p BUSINESS_CENTRAL_MEMORY_LIMIT="2Gi" -e JAVA_OPTS_APPEND=-Derrai.bus.enable_sse_support=false -n ccd-project && break || sleep 2; done'
