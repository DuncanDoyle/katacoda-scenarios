#!/bin/bash
ssh root@host01 'echo "Importing Red Hat Process Automation Manager 7 Image Streams into OpenShift." >> script.log'
# Need to temporarily patch the ImageStreams file to point to tech-preview version.
ssh root@host01 'for i in {1..200}; do oc create -f https://raw.githubusercontent.com/jboss-container-images/rhpam-7-openshift-image/7.0.2.GA/rhpam70-image-streams.yaml -n openshift && break || sleep 2; done'
ssh root@host01 'echo "Importing Red Hat Process Automation Manager 7 - Trial template into OpenShift." >> script.log'
#Remove persistent volume claim from the template, as we do not have PVC in Katacoda
#ssh root@host01 'for i in {1..200}; do wget https://raw.githubusercontent.com/jboss-container-images/rhdm-7-openshift-image/7.0.1.GA/templates/rhdm70-full.yaml && break || sleep 2; done'
#ssh root@host01 'for i in {1..200}; do cat rhdm70-full.yaml | sed "/rhdmcentr-pvol/,+1 d" | sed "/claimName/d" | sed "s/haproxy.router.openshift.io\/timeout: 60s/haproxy.router.openshift.io\/timeout: 600s/g" | head -n -12 > rhdm70-full-no-persistence.yaml && break || sleep 2; done'
#ssh root@host01 'for i in {1..200}; do oc create -f rhdm70-full-no-persistence.yaml -n openshift && break || sleep 2; done'
ssh root@host01 'for i in {1..200}; do oc create -f https://raw.githubusercontent.com/jboss-container-images/rhpam-7-openshift-image/7.0.2.GA/templates/rhpam70-trial-ephemeral.yaml -n openshift && break || sleep 2; done'
ssh root@host01 'echo "Logging into OpenShift as developer." >> script.log'
ssh root@host01 'for i in {1..200}; do oc login -u developer -p developer && break || sleep 2; done'
ssh root@host01 'echo "Creating new demo project in OpenShift." >> script.log'
ssh root@host01 'for i in {1..200}; do oc new-project rhpam7-workshop --display-name="RHPAM 7 Reporting" --description="Red Hat Process Automation Manager 7 - Reporting Project" && break || sleep 2; done'
ssh root@host01 'echo "Importing secrets and service accounts."'
#ssh root@host01 'for i in {1..200}; do oc create -f https://raw.githubusercontent.com/jboss-container-images/rhdm-7-openshift-image/7.0.1.GA/decisioncentral-app-secret.yaml && break || sleep 2; done'
#ssh root@host01 'for i in {1..200}; do oc create -f https://raw.githubusercontent.com/jboss-container-images/rhdm-7-openshift-image/7.0.1.GA/kieserver-app-secret.yaml && break || sleep 2; done'
ssh root@host01 'echo "Creating Business Central and KIE Server containers in OpenShift." >> script.log'
ssh root@host01 'for i in {1..200}; do oc new-app --template=rhpam70-trial-ephemeral -p APPLICATION_NAME="rhpam7-workshop" -p IMAGE_STREAM_NAMESPACE="openshift" -p KIE_ADMIN_USER="developer" -p KIE_SERVER_CONTROLLER_USER="kieserver" -p KIE_SERVER_USER="kieserver" -p DEFAULT_PASSWORD="developer" -p MAVEN_REPO_USERNAME="developer" -p MAVEN_REPO_PASSWORD="developer" -p BUSINESS_CENTRAL_MEMORY_LIMIT="2Gi" -e JAVA_OPTS_APPEND=-Derrai.bus.enable_sse_support=false -n rhpam7-workshop && break || sleep 2; done'
