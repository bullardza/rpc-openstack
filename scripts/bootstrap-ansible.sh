#!/usr/bin/env bash
# Copyright 2014-2017 , Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## Shell Opts ----------------------------------------------------------------

set -e -u -x
set -o pipefail

## Vars ----------------------------------------------------------------------

export BASE_DIR=${BASE_DIR:-"/opt/rpc-openstack"}
export OA_DIR="${BASE_DIR}/openstack-ansible"
export RPCD_DIR="${BASE_DIR}/rpcd"
# Set the role fetch mode to any option [galaxy, git-clone]
export ANSIBLE_ROLE_FETCH_MODE=${ANSIBLE_ROLE_FETCH_MODE:-galaxy}

## Main ----------------------------------------------------------------------

# Confirm OA_DIR is properly checked out
submodulestatus=$(git submodule status ${OA_DIR})
case "${submodulestatus:0:1}" in
  "-")
    echo "ERROR: rpc-openstack submodule is not properly checked out"
    exit 1
    ;;
  "+")
    echo "WARNING: rpc-openstack submodule does not match the expected SHA"
    ;;
  "U")
    echo "ERROR: rpc-openstack submodule has merge conflicts"
    exit 1
    ;;
esac

# begin the bootstrap process
pushd ${OA_DIR}

  ./scripts/bootstrap-ansible.sh

  # This removes legacy roles which were downloaded into the
  # rpc-o folder structure, dirtying the git tree.
  ansible-galaxy remove --roles-path /opt/rpc-openstack/rpcd/playbooks/roles/ \
                        ceph-common ceph-mon ceph-osd \
                        ceph.ceph-common ceph.ceph-mon ceph.ceph-osd \
                        rcbops_openstack-ops

  if [[ "${ANSIBLE_ROLE_FETCH_MODE}" == 'galaxy' ]];then
    # Pull all required roles.
    ansible-galaxy install --role-file="${BASE_DIR}/ansible-role-requirements.yml" \
                           --force
  elif [[ "${ANSIBLE_ROLE_FETCH_MODE}" == 'git-clone' ]];then
    ansible-playbook ${OA_DIR}/tests/get-ansible-role-requirements.yml \
                     -i ${OA_DIR}/tests/test-inventory.ini \
                     -e role_file="${BASE_DIR}/ansible-role-requirements.yml"
  else
    echo "Please set the ANSIBLE_ROLE_FETCH_MODE to either of the following options ['galaxy', 'git-clone']"
    exit 99
  fi

popd
