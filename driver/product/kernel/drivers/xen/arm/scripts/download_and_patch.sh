#!/bin/bash
# SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
#
# (C) COPYRIGHT 2021-2022 ARM Limited. All rights reserved.
#
# This program is free software and is provided to you under the terms of the
# GNU General Public License version 2 as published by the Free Software
# Foundation, and any use by you of this program is subject to the terms
# of such GNU license.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, you can access it online at
# http://www.gnu.org/licenses/gpl-2.0.html.
#

# Script to download and patch Xen hypervisor source.
#
# Usage:
#   cd <your_path/xen>
#   ./download_and_patch.sh <pv/hv>
#   example: ./download_and_patch.sh pv

set -e

usage_example() {
    script_name=$(basename "$0")
    echo -e "$script_name <virtualisation type>"
    echo -e "\tvirtualisation type: pv or hv"
    echo -e "example:\n\t$script_name pv"
}

PATCH_LIST=("host-xen.patch")
PATCHES=$PWD/patches

if [ $# -ne 1 ]
then
    usage_example
    exit -1
fi

mkdir -p host

echo $PATCH_LIST

function prep_host_xen() {

    echo "Preparing Xen hypervisor..."
    pushd host
    if [ ! -d "xen/.git" ]; then
        git clone git://xenbits.xen.org/xen.git
    fi
    pushd xen/xen
    git stash
    git clean -fd
    git checkout c93b520a41f2787dd76bfb2e454836d1d5787505
    popd
    popd
}

function apply_patches() {
    echo "Applying patches"
    pushd host/xen/$1
    for f in "${PATCH_LIST[@]}" ; do
        echo "Patch file $f"
        patch -f -N -p 1 -i $PATCHES/$f
    done
    popd
}

prep_host_xen $1
if [ -d "$PATCHES" ]; then
    apply_patches
else
    echo "Error: missing patches folder!"
    echo "Please copy the patches folder in the current directory!"
    exit -1
fi
echo "Script complete"
