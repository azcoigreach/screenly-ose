FROM hypriot/armhf-busybox

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
RUN useradd pi

# Install config file and file structure
RUN mkdir -p /home/pi/.screenly /home/pi/screenly /home/pi/screenly_assets
COPY ansible/roles/screenly/files/screenly.conf /home/pi/.screenly/screenly.conf

# Copy in code base
COPY . /home/pi/screenly
RUN chown -R pi:pi /home/pi

USER root
WORKDIR /home/pi/screenly

EXPOSE 8080

CMD python server.py
