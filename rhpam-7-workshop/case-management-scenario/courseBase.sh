#!/bin/bash
ssh root@host01 'echo "Login into the secured RedHat registry." >> script.log'
ssh root@host01 'echo "Importing Red Hat Process Automation Manager 7 Image Streams into OpenShift." >> script.log'
ssh root@host01 'for i in {1..200}; do oc create -f https://raw.githubusercontent.com/jboss-container-images/rhpam-7-openshift-image/7.0.x/rhpam70-image-streams.yaml -n openshift && break || sleep 2; done'
ssh root@host01 'echo "Importing Red Hat Process Automation Manager 7 - Trial ephimeral template into OpenShift." >> script.log'
ssh root@host01 'for i in {1..200}; do oc create -f https://raw.githubusercontent.com/jboss-container-images/rhpam-7-openshift-image/7.0.x/templates/rhpam70-trial-ephemeral.yaml -n openshift && break || sleep 2; done'
ssh root@host01 'echo "Logging into OpenShift as developer." >> script.log'
ssh root@host01 'for i in {1..200}; do oc login -u developer -p developer && break || sleep 2; done'
ssh root@host01 'echo "Creating new credit-card-dispute project in OpenShift." >> script.log'
ssh root@host01 'for i in {1..200}; do oc new-project credit-card-dispute --display-name="Credit Card Dispute" --description="Red Hat Process Manager 7 - Credit Card Dispute" && break || sleep 2; done'
ssh root@host01 'echo "Creating Business Central and Kie Server containers in OpenShift." >> script.log'
ssh root@host01 'for i in {1..200}; do oc new-app --template=rhpam70-trial-ephemeral -p APPLICATION_NAME="cc-dispute" -p IMAGE_STREAM_NAMESPACE="openshift"  && break || sleep 2; done'

