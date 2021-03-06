FROM alpine

LABEL version="1.0.13"
LABEL name="kubectl-deploy"
LABEL repository="http://github.com/fractos/kubectl-deploy"
LABEL homepage="http://github.com/fractos/kubectl-deploy"

LABEL maintainer="Adam Christie <fractos@gmail.com>"
LABEL com.github.actions.name="Kubernetes deployment rollback - kubectl-deploy"
LABEL com.github.actions.description="This will apply a deployment using kubectl, verify the deployment and roll it back if it failed."
LABEL com.github.actions.icon="refresh-cw"
LABEL com.github.actions.color="green"

ENV KUBECTL_VERSION "v1.13.12"
ENV APPLY_FLAGS ""
ENV UNDO_FLAGS ""
ENV ATTEMPT_ROLLBACK "1"

COPY LICENSE README.md /
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN apk add py-pip curl
RUN pip install awscli

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]