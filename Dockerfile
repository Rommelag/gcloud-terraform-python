FROM python:3.12

ENV TERRAFORM_VERSION=1.9.8
ENV PACKER_VERSION=1.11.2
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1


RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils unzip jq ca-certificates curl gnupg && \
    curl --silent https://packages.cloud.google.com/apt/doc/apt-key.gpg \
        | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
        > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get install -y --no-install-recommends google-cloud-cli

RUN curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip && \
    curl -L https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -o /tmp/packer.zip && \
    unzip -o /tmp/terraform.zip -d /usr/local/bin/ && \
    unzip -o /tmp/packer.zip -d /usr/local/bin/ && \
    rm -rf /tmp/*.zip

# Install python dependencies - uv
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"

RUN pip install joblib==0.14.1 python-jenkins==1.6.0 pylint==2.4.4 natsort==7.0.0 google-api-python-client==1.7.11 google-auth==1.10.1 google-auth-httplib2==0.0.3

RUN apt-get remove -y unzip apt-utils && apt-get clean && rm -rf /var/lib/apt/lists/*