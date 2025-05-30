#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# define: <public-image-name>,<local-image-name>
# -> <local-image-name> is used in all deployments (!)
images="
denver74/doom:v1,doom:cinq-kubedoom-2025
dockvx/ascii-image-converter:1.13.1,dockvx/ascii-image-converter:cinq-kubecon-2023
denver74/lookinthelogs:v1,lookinthelogs:cinq-kubedoom-2025
denver74/score:v2,score:cinq-kubedoom-2025
kindest/node:v1.33.0@sha256:02f73d6ae3f11ad5d543f16736a2cb2a63a300ad60e81dac22099b0b04784a4e,kind-node:v1.33.0_cinq-kubedoom-2025
registry:2
"

# define image archives path
image_archive_path=${SCRIPT_DIR}/../registry/image-archives/


echo "Registries logout to prevent credential mismatch"
echo "- - - - - - - - - - - - - - - - - - - - - - - - "
docker logout
docker logout ghcr.io
echo

echo "Pulling, tagging and saving the following public images: "
echo "- - - - - - - - - - - - - - - - - - - - - - - - "
for image in $images
do
  echo "- $image"
done
echo "- - - - - - - - - - - - - - - - - - - - - - - - "
echo

for image in $images
do
  image_remote_name=${image%,*}
  image_local_name=${image#*,}
  image_tag_name=${image_local_name##*/}
  image_archive_name=${image_tag_name/:/_}.tar.gz

#  echo "PREP image:  ${image_remote_name}"
#  echo "local:   ${image_local_name}"
#  echo "tag:     ${image_tag_name}"
#  echo "archive: ${image_archive_name}"
#  echo

  echo "Start pulling, tagging and saving of image: ${image_remote_name}"
  echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
  docker pull ${image_remote_name}
  docker tag ${image_remote_name} ${image_tag_name}
  # this overwrites existing archives (!)
  docker save ${image_tag_name} | gzip > ${image_archive_path}${image_archive_name}
  echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
  echo "Image saved to: ${image_archive_path}${image_archive_name}"
  echo
done
