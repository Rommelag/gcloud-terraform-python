FROM python:3.6

ENV TERRAFORM_VERSION=0.11.7
ENV PACKER_VERSION=1.2.5
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && \
    apt-get update && apt-get install -y --no-install-recommends unzip jq lsb-release && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl --silent https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y google-cloud-sdk -y && \
    curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip && \
    curl -L https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -o /tmp/packer.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin/ && \
    unzip /tmp/packer.zip -d /usr/local/bin/ && \
    pip install joblib==0.12.0 python-jenkins==1.0.2 pylint==2.1.1 natsort==5.5.0 google-api-python-client==1.7.4 google-auth==1.5.1 google-auth-httplib2==0.0.3 && \
    rm -rf /tmp/*.zip && \
    apt-get remove -y unzip lsb-release apt-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
