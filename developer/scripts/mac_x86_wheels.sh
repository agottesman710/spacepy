#!/usr/bin/env zsh

# Get miniconda if you need it
#wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
#bash ./Miniconda3-latest-MacOSX-x86_64.sh -b -p ~/opt/miniconda
VERSIONS=(
    "3.10"
)
for PYVER in "${VERSIONS[@]}"
do
    ENVNAME=spacepy${PYVER//.}
    ~/opt/miniconda/bin/conda create -y -n ${ENVNAME} python=${PYVER}
    source ~/opt/miniconda/bin/activate ${ENVNAME}
    if [ ${PYVER} = "3.9" ]; then
	conda install -y python-build wheel gfortran~=11.2.0 "cython<3"
	BUILD=python-build
    elif [ ${PYVER} = "3.12" ]; then
	conda install -y python-build wheel gfortran~=11.2.0 "cython<3"
	BUILD=python-build
    else
	conda install -y python-build wheel gfortran~=11.2.0
	BUILD=python-build
    fi
    rm -rf build
    PYTHONNOUSERSITE=1 PYTHONPATH= SPACEPY_RELEASE=1 SDKROOT=/opt/MacOSX10.9.sdk ${BUILD} -w -n -x .
    conda deactivate
    # if these vars aren't cleared, next conda env will use them for compilers
    badvars=$(env | sed -n 's/^\(CONDA_BACKUP_[^=]*\)=.*/\1/p')
    unset $(echo $badvars)
    export $(echo $badvars)
    ~/opt/miniconda/bin/conda env remove -y --name ${ENVNAME}
done
#rm -rf ~/opt/miniconda
#rm ./Miniconda3-latest-MacOSX-x86_64.sh
