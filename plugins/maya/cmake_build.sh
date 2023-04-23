#
# Build CGRU Maya plugin
#
# export MAYA_CGRU_LOCATION=/home/data/code/cgru/plugins/maya
export MAYA_VERSION=2023
export MAYA_VERSION=2024
export MAYA_VERSION=2025
export MAYA_LOCATION=/usr/autodesk/maya${MAYA_VERSION}
cur_dir=`pwd`
tmp_dir="build"
deploy_dir="${cur_dir}/mll"

mkdir -p $tmp_dir
pushd $tmp_dir

cmake3 -L -G "Unix Makefiles" \
-DCMAKE_INSTALL_PREFIX=${deploy_dir} \
-DCMAKE_BUILD_TYPE="Release" \
../src

popd

if [ $? -eq 0 ]
then
    echo "* "
    echo "* cmake config completed."
    echo "* "
    echo "* run \"make -C ${tmp_dir} install\" " 
    make -C ${tmp_dir} install
else
    echo "* "
    echo "* cmake config error!"
    echo "* "
fi
