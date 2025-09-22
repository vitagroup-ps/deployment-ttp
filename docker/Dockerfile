FROM mosaicgreifswald/wildfly:36

RUN mkdir -p /entrypoint-wildfly-cli \
             /entrypoint-wildfly-deployments \
             /entrypoint-wildfly-logs \
             /entrypoint-wildfly-addins

COPY ./ttp/addins/      /entrypoint-wildfly-addins/
COPY ./ttp/deployments/ /entrypoint-wildfly-deployments/
COPY ./ttp/jboss/       /entrypoint-wildfly-cli/
COPY ./ttp/logs/        /entrypoint-wildfly-logs/

USER root
RUN chmod -R go+rX /entrypoint-wildfly-cli /entrypoint-wildfly-deployments /entrypoint-wildfly-addins && \
    chmod -R 777  /entrypoint-wildfly-logs
USER 1000

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "./wait-for-it.sh mysql:3306 -t 120 && ./run.sh"]