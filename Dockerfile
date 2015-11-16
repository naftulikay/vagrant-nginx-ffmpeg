FROM phusion/baseimage:0.9.17

MAINTAINER "Naftuli Tzvi Kay <rfkrocktk@gmail.com>"

RUN apt-get -y update >/dev/null && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y python2.7-dev build-essential git \
        python-pip >/dev/null

RUN pip install ansible >/dev/null

ADD ansible/inventory /etc/ansible/inventory
ADD ansible/playbook.yml /etc/ansible/playbook.yml
ADD ansible/templates /etc/ansible/templates

ADD scripts/nginx-service.sh /etc/service/nginx/run
RUN chmod 0755 /etc/service/nginx/run

WORKDIR /etc/ansible

RUN PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true \
    ansible-playbook playbook.yml -c local -i /etc/ansible/inventory

EXPOSE 1935

ENTRYPOINT ["/sbin/my_init"]

CMD ["/bin/bash"]
