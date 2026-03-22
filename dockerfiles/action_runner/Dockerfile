FROM summerwind/actions-runner:ubuntu-22.04

# Update package lists and install system dependencies
RUN sudo apt-get update && sudo apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    jq \
    vim \
    nano \
    tree \
    htop \
    net-tools \
    iputils-ping \
    dnsutils \
    ca-certificates \
    gnupg \
    lsb-release \
    openssh-client \
    && sudo rm -rf /var/lib/apt/lists/*

# Install Python 3.13 from source (simplified approach without symlinks)
RUN sudo apt-get update && sudo apt-get install -y \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libsqlite3-dev \
    libreadline-dev \
    libffi-dev \
    libbz2-dev \
    && sudo rm -rf /var/lib/apt/lists/* \
    && cd /tmp \
    && wget https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tgz \
    && echo "12445c7b3db3126c41190bfdc1c8239c39c719404e844babbd015a1bc3fafcd4  Python-3.13.0.tgz" | sha256sum -c - \
    && tar -xzf Python-3.13.0.tgz \
    && cd Python-3.13.0 \
    && ./configure --enable-optimizations --with-ensurepip=install \
    && make -j$(nproc) \
    && sudo make altinstall \
    && sudo rm -rf /tmp/Python-3.13.0*

# Copy packages.yaml for reference
COPY packages.yaml /opt/packages.yaml

# Install yq for YAML parsing
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /tmp/yq && \
    sudo mv /tmp/yq /usr/bin/yq && \
    sudo chmod +x /usr/bin/yq

# Install Terraform
RUN TERRAFORM_VERSION=$(yq eval '.versions.cloud_tools.terraform' /opt/packages.yaml) && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        TERRAFORM_ARCH="amd64"; \
    elif [ "$ARCH" = "arm64" ]; then \
        TERRAFORM_ARCH="arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TERRAFORM_ARCH}.zip -O /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /tmp && \
    sudo mv /tmp/terraform /usr/local/bin/terraform && \
    sudo chmod +x /usr/local/bin/terraform && \
    rm -rf /tmp/terraform.zip

# Install AWS CLI
RUN AWS_CLI_VERSION=$(yq eval '.versions.cloud_tools.aws_cli' /opt/packages.yaml) && \
    ARCH=$(dpkg --print-architecture) && \
    cd /tmp && \
    if [ "$ARCH" = "amd64" ]; then \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    elif [ "$ARCH" = "arm64" ]; then \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    unzip awscliv2.zip && \
    sudo ./aws/install && \
    rm -rf awscliv2.zip aws/

# Install kubectl
RUN KUBECTL_VERSION=$(yq eval '.versions.cloud_tools.kubectl' /opt/packages.yaml) && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        KUBECTL_ARCH="amd64"; \
    elif [ "$ARCH" = "arm64" ]; then \
        KUBECTL_ARCH="arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    cd /tmp && \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl" && \
    sudo chmod +x kubectl && \
    sudo mv kubectl /usr/local/bin/

# Install go-task
RUN GO_TASK_VERSION=$(yq eval '.versions.cloud_tools.go_task' /opt/packages.yaml) && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        TASK_ARCH="amd64"; \
    elif [ "$ARCH" = "arm64" ]; then \
        TASK_ARCH="arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    if [ "$GO_TASK_VERSION" = "latest" ]; then \
        sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /tmp && sudo mv /tmp/task /usr/local/bin/; \
    else \
        sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /tmp v${GO_TASK_VERSION} && sudo mv /tmp/task /usr/local/bin/; \
    fi

# Create and activate virtual environment for Python packages
RUN sudo mkdir -p /opt/venv && sudo chown $(whoami):$(whoami) /opt/venv && python3.13 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages with versions from packages.yaml
RUN yq eval '.versions.python_requirements' /opt/packages.yaml > /tmp/requirements.txt && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Install Ansible collections with versions from packages.yaml
RUN for collection in $(yq eval '.versions.ansible_collections[] | .name' /opt/packages.yaml); do \
        version=$(yq eval ".versions.ansible_collections[] | select(.name == \"$collection\") | .version" /opt/packages.yaml); \
        if [ "$version" = "latest" ]; then \
            ansible-galaxy collection install "$collection"; \
        else \
            ansible-galaxy collection install "$collection:$version"; \
        fi; \
    done

# Install 1Password CLI
RUN ONEPASSWORD_VERSION=$(yq eval '.versions.security.onepassword_cli' /opt/packages.yaml) && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        OP_ARCH="amd64"; \
    elif [ "$ARCH" = "arm64" ]; then \
        OP_ARCH="arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    wget https://cache.agilebits.com/dist/1P/op2/pkg/v${ONEPASSWORD_VERSION}/op_linux_${OP_ARCH}_v${ONEPASSWORD_VERSION}.zip -O /tmp/op.zip && \
    unzip /tmp/op.zip -d /tmp && \
    sudo mv /tmp/op /usr/local/bin/op && \
    sudo chmod +x /usr/local/bin/op && \
    rm -rf /tmp/op.zip

# Ensure virtual environment is available
ENV PATH="/opt/venv/bin:$PATH"
