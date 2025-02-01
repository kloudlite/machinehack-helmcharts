#! /usr/bin/env bash

for dir in charts/*/; do
  cat >>.static-pages/env-template.yml <<EOF
- name: $dir
  helmchartInfo:
    url: "https://kloudlite.github.io/machinehack-helmcharts"
    name: "jupyter-notebook"
    version: "${CHART_VERSION}"
  helmValues: $(yq -r <"$dir/values.yaml")
EOF
done
