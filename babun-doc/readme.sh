#!/bin/bash
# shellcheck disable=SC2129
set -e -f -o pipefail

readme="../README.adoc"

echo "// THIS DOCUMENT WAS GENERATED. DO NOT EDIT IT." > "$readme"
echo "" >> "$readme"
cat adoc/_header.adoc >> "$readme"
cat adoc/_screencast.adoc >> "$readme"
cat adoc/_installation.adoc >> "$readme"
cat adoc/_usage.adoc >> "$readme"
echo "" >> "$readme"
echo "== Screenshots" >> "$readme"
echo "" >> "$readme"
cat adoc/_screenshots.adoc >> "$readme"
echo "" >> "$readme"
echo "== Development" >> "$readme"
echo "" >> "$readme"
cat adoc/_development.adoc >> "$readme"
cat adoc/_licence.adoc >> "$readme"
cat adoc/_supporters.adoc >> "$readme"
cat adoc/_footer.adoc >> "$readme"
