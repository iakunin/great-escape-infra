#!/usr/bin/env bash

set -euo pipefail

## Terraform does not support temporary files:
## https://github.com/hashicorp/terraform/issues/21308
## So, to use templates with gcloud - we need to:
## - render template by terrafrom in a normal way
## - pass base64 encoded content to script
## - put it as local file
## - run gcloud workflows deploy and reference this file
##
## Fuck my life :(

WF_NAME="${1}"
WF_REGION="${2}"
WF_SA="${3}"
WF_BODY="${4}"

TMP_DIR=${TMPDIR:-/tmp}
TMP_FILE=$(mktemp ${TMP_DIR}/${WF_NAME}.XXXXXX)
trap "rm -f \"${TMP_FILE}\"" EXIT

echo "${WF_BODY}" | base64 -d >"${TMP_FILE}"
gcloud beta workflows deploy "${WF_NAME}" --location="${WF_REGION}" --service-account="${WF_SA}" --source="${TMP_FILE}"

exit 0
