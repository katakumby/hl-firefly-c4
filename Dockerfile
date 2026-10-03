# check=skip=InvalidDefaultArgInFrom
ARG NODE_VERSION
ARG STRUCTURIZR_VERSION
FROM node:${NODE_VERSION}-bookworm-slim AS mermaid
WORKDIR /opt/renderers
ENV PUPPETEER_SKIP_DOWNLOAD=true
COPY scripts/renderers/package*.json ./
RUN npm ci --ignore-scripts --omit=dev --no-audit --no-fund

FROM structurizr/structurizr:${STRUCTURIZR_VERSION}-playwright
ARG PLANTUML_VERSION
USER root
RUN apt-get update && apt-get install -y --no-install-recommends python3 graphviz=2.42.2-9ubuntu0.1 curl fonts-dejavu-core=2.37-8 && rm -rf /var/lib/apt/lists/*
# The jar embeds the C4 standard library; runtime rendering needs no remote includes.
RUN mkdir -p /opt/plantuml && curl --fail --location --retry 3 \
    "https://repo.maven.apache.org/maven2/net/sourceforge/plantuml/plantuml/${PLANTUML_VERSION}/plantuml-${PLANTUML_VERSION}.jar" \
    --output /opt/plantuml/plantuml.jar \
    && echo "4a01ea09b317180fb8e7eef712dfdca725409d2ee1919e4b5adfe9d8362b6fe5  /opt/plantuml/plantuml.jar" | sha256sum --check -
COPY --from=mermaid /usr/local/bin/node /usr/local/bin/node
COPY --from=mermaid /opt/renderers /opt/renderers
COPY scripts/renderers/configure.py /opt/renderers/configure.py
RUN python3 /opt/renderers/configure.py
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 HOME=/tmp
USER 1000:1000
WORKDIR /workspace
ENTRYPOINT ["python3", "-B", "/workspace/scripts/architecture.py"]
CMD ["--help"]
