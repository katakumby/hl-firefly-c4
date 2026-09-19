# check=skip=InvalidDefaultArgInFrom

# The version is intentionally required from .env through Compose.
ARG STRUCTURIZR_VERSION
FROM structurizr/structurizr:${STRUCTURIZR_VERSION}-playwright

# Build once (or publish through the corporate image registry). No pip packages.
USER root
RUN ["apt-get", "update"]
RUN ["env", "DEBIAN_FRONTEND=noninteractive", "apt-get", "install", "-y", "--no-install-recommends", "python3"]
RUN ["python3", "-c", "import shutil; shutil.rmtree('/var/lib/apt/lists')"]

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 HOME=/tmp
USER 1000:1000
WORKDIR /workspace
ENTRYPOINT ["python3", "-B", "/workspace/architecture/scripts/architecture.py"]
CMD ["--help"]
