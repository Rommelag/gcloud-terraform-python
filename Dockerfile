FROM python:3.12

ENV TERRAFORM_VERSION=1.9.5
ENV PACKER_VERSION=1.11.2
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils  && \
    apt-get update && apt-get install -y --no-install-recommends unzip jq && \
    apt-get update && apt-get install -y apt-transport-https ca-certificates gnupg curl  && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg  && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list  && \
    apt update && apt install -y google-cloud-cli=491.0.0-0  && \
    curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip  && \
    curl -L https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -o /tmp/packer.zip  && \
    unzip -o /tmp/terraform.zip -d /usr/local/bin/  && \
    unzip -o /tmp/packer.zip -d /usr/local/bin/  && \
    pip install joblib==1.4.2 python-jenkins==1.8.2 pylint==3.2.7 natsort==8.4.0 google-api-python-client==2.143.0 google-auth==2.34.0 google-auth-httplib2==0.2.0  && \
    rm -rf /tmp/*.zip  && \
    apt-get remove -y unzip apt-utils  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*