# Agenthon Team 728 — Track 4 Final analyze image (model-free minimal baseline)
# Optional ship-agent B (claim-rail): see Dockerfile.claim-rail — default remains THIS file (A).
#
# Implements the published interface:
#   analyze --task /input/task.json --corpus /input/corpus --out /output/answer.json
#
# Rules (see FINAL-GAPS + vendor SUBMISSION_CLI.md):
#   - LABEL qfbench2.interface_version="2.0"
#   - No VOLUME (including inherited from base) — Final Failed if present
#   - linux/amd64; digests-pinned base as feasible
#   - category api; this agent calls no House model (models: [] in descriptor)
#
# Build context MUST be:
#   vendor/track4-analysis-public/baselines
# Example (engine required — this prep box often has only a stub wrapper at
# /home/box/bin/docker that execs missing /usr/bin/docker):
#   docker build --platform linux/amd64 -f final-pack/Dockerfile \
#     -t team728-t4-analyze:local \
#     vendor/track4-analysis-public/baselines
# Or: ./final-pack/build-and-smoke.sh
#
# CPU-only smoke WITHOUT Docker (stdlib baseline; same CLI verb):
#   PYTHONPATH=vendor/track4-analysis-public/baselines python3 \
#     vendor/track4-analysis-public/baselines/baseline_agent.py analyze \
#     --task vendor/track4-analysis-public/units/t4-EXAMPLE-eps-beat/task.json \
#     --corpus vendor/track4-analysis-public/units/t4-EXAMPLE-eps-beat/corpus \
#     --out /tmp/answer.json
#
# Base digest resolved 2026-10-22 from Docker Hub tag python:3.13-slim (linux/amd64).
# Registry config for this digest reports Volumes: null (no inherited VOLUME).
# Re-check Volumes after any base retag/rebuild:
#   docker image inspect --format '{{json .Config.Volumes}}' <image>
# Never add a VOLUME instruction below.

FROM python:3.13-slim@sha256:d879ed88565a7a3c614b980b369d4a5025a9d057b71f93d09fc6d0b2ca823a18

LABEL qfbench2.interface_version="2.0"
LABEL org.opencontainers.image.source="https://github.com/er-s-an/team728-t4-analyze"
LABEL org.opencontainers.image.description="Team 728 Track 4 analyze — vendor minimal baseline (stdlib)"

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY baseline_agent ./baseline_agent
COPY baseline_agent.py .

# Verb `analyze` is the container COMMAND; ENTRYPOINT consumes it as argv[1].
# Do NOT add VOLUME.
ENTRYPOINT ["python", "baseline_agent.py"]
CMD ["analyze", "--help"]
