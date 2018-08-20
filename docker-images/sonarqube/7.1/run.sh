USER root

############################################
# Install PostgreSQL
############################################

RUN yum -y localinstall http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm
RUN yum -y install postgresql93-server postgresql93
RUN /etc/init.d/postgresql-9.3 initdb
RUN sed -i "s/peer/trust/g" /var/lib/pgsql/9.3/data/pg_hba.conf
RUN sed -i "s/ident/md5/g" /var/lib/pgsql/9.3/data/pg_hba.conf
RUN echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/9.3/data/pg_hba.conf

RUN echo "listen_addresses='*'" >> /var/lib/pgsql/9.3/data/postgresql.conf
RUN /etc/init.d/postgresql-9.3 start && \
	psql -U postgres --command "CREATE USER sonar WITH SUPERUSER PASSWORD 'sonar';" && \
	runuser -l postgres -c "createdb -O sonar sonar"