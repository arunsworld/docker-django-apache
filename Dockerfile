FROM ubuntu:bionic

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
ENV PYTHONUNBUFFERED 1

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 apache2 \
	procps screen vim \
    git mercurial subversion && \
    apt-get install -y curl grep sed dpkg && \
    apt-get install -y dirmngr gnupg && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 && \
    apt-get install -y apt-transport-https ca-certificates && \
    sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list' && \
    apt-get update && \
    apt-get install -y libapache2-mod-passenger && \
    apt-get clean && \
    a2enmod passenger && \
    ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load && \
    a2enmod headers

RUN wget --quiet https://repo.continuum.io/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    conda update -n base -y conda \
    && conda update --prefix /opt/conda -y anaconda \
    && conda clean -a -y

RUN pip install --upgrade pip && pip --no-cache-dir install msgpack django djangorestframework django-cors-headers behave django-admin-view-permission coreapi djangorestframework-simplejwt django-rest-swagger

ADD PyHamcrest-master.tar.gz /tmp/

RUN cd /tmp/PyHamcrest-master && \
    python setup.py install && \
    rm -r /tmp/PyHamcrest-master

COPY apache2-foreground /bin/
COPY stop /bin/

EXPOSE 80
CMD ["apache2-foreground"]
