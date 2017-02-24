FROM resin/rpi-raspbian:latest

RUN apt-get update && apt-get upgrade
RUN apt-get -y install git-core net-tools \
    python-pip python-netifaces python-simplejson python-imaging python-dev \
    sqlite3 \ 
    libffi-dev libssl-dev gcc && \
    apt-get clean

# Install Python requirements
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Create runtime user
# RUN useradd pi

# Install config file and file structure
RUN mkdir -p /root/.screenly /root/screenly /root/screenly_assets
COPY ansible/roles/screenly/files/screenly.conf /root/.screenly/screenly.conf

# Copy in code base
COPY . /root/screenly
# RUN chown -R pi:pi /root/screenly

# USER pi
WORKDIR /root/screenly

EXPOSE 8080

CMD python server.py
