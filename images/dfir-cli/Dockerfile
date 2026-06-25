# DFIR CLI toolbox
FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install forensic tools and utilities (including build tools for Python packages)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates tzdata \
      sleuthkit \
      testdisk \
      foremost \
      ewf-tools \
      dosfstools \
      mtools \
      exiftool \
      hashdeep \
      yara \
      tshark \
      python2.7 python2.7-dev \
      python3 python3-pip python3-venv \
      less file procps \
      vim nano \
      curl wget \
      grep findutils \
      git \
      build-essential python3-dev \
      && pip3 install --no-cache-dir \
         volatility3 \
         pycryptodome \
         distorm3 \
      && rm -rf /var/lib/apt/lists/*

# Install Volatility 2 (for legacy Windows XP/Vista/2000 support)
RUN git clone https://github.com/volatilityfoundation/volatility.git /opt/volatility2 \
    && cd /opt/volatility2 \
    && git checkout 2.6.1 \
    && printf '#!/bin/sh\nexec python2.7 /opt/volatility2/vol.py "$@"\n' > /usr/local/bin/vol2 \
    && chmod +x /usr/local/bin/vol2 /opt/volatility2/vol.py

# Install Python 2.7 dependencies for Volatility 2
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    python2.7 get-pip.py && \
    rm get-pip.py && \
    pip install --no-cache-dir \
      pycryptodome \
      distorm3

# Copy banner, entrypoint script, and coc-log utility
COPY images/dfir-cli/banner.txt /etc/banner.txt
COPY images/dfir-cli/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/coc-log /usr/local/bin/coc-log

# Make scripts executable
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/coc-log

WORKDIR /cases

# Set entrypoint to display banner and handle commands
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command for interactive mode
CMD ["/bin/bash"]
