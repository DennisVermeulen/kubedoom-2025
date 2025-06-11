#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# define image archives path
image_archive_path=${SCRIPT_DIR}/../registry/image-archives/

# load registry image from archive
registry_image_archive=${image_archive_path}/registry_2.tar.gz
echo "Load image from: $registry_image_archive"
echo "- - - - - - - - - - - - - - - - - - - - - - - - "
docker load < $registry_image_archive
echo

# create registry container unless it already exists
reg_name='kind-registry'
reg_port='6200'
reg_cluster_port='6200'
if [ "$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)" != 'true' ]; then
  docker run \
    -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" \
    registry:2
fi

# load image archives and push to local registry (skip kind and registry)
image_archives=$(find ${image_archive_path}/*.tar.gz -type f | egrep -v "registry_2")
for image_archive in $image_archives
do
  echo "Load image from: $image_archive"
  echo "- - - - - - - - - - - - - - - - - - - - - - - - "
  docker load < $image_archive
  image_name_tag=$(tar -zxf $image_archive -O manifest.json |  jq -r '.[].RepoTags[]')
  docker tag $image_name_tag localhost:${reg_port}/$image_name_tag
  docker push localhost:${reg_port}/$image_name_tag
  echo "- - - - - - - - - - - - - - - - - - - - - - - - "
  echo "Pushed image to local registry: localhost:${reg_port}/$image_name_tag"
  echo
done

# Check registry contents
# curl -X GET http://localhost:5001/v2/_catalog | jq