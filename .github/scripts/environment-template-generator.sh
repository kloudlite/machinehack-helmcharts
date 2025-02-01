#! /usr/bin/env bash

for dir in charts/*/; do
  cat >>.static-pages/env-template.yml <<EOF
- name: $(basename "$dir")
  helmchartInfo:
    url: "https://kloudlite.github.io/machinehack-helmcharts"
    name: $(basename "$dir")
    version: "${CHART_VERSION}"
  helmValues: 
$(yq -r <"$dir/values.yaml" | sed 's/^/    /')
EOF
done
