#!/bin/bash

INSTALL_PROTOC=$PWD/scripts/install_protoc.sh
MODELS_DIR=$PWD/third_party/models

PYTHON=python
INSTALL="install"
for arg do
  shift
  case $arg in
    develop) INSTALL="develop";;
    install) INSTALL="install";;
    *python*) PYTHON=$arg;;
    *) set -- "$@" "$arg";;
  esac
done
echo $PYTHON

# install protoc
echo "Downloading protoc"
source $INSTALL_PROTOC
PROTOC=$PWD/data/protoc/bin/protoc

# install tensorflow models
git submodule update --init

pushd $MODELS_DIR/research
echo $PWD
echo "Installing object detection library"
echo $PROTOC
$PROTOC object_detection/protos/*.proto --python_out=.
echo $PYTHON setup.py $INSTALL $@
popd

pushd $MODELS_DIR/research/slim
echo $PWD
echo "Installing slim library"
echo $PYTHON setup.py $INSTALL $@
popd

echo "Installing tf_trt_models"
echo $PWD
echo $PYTHON setup.py $INSTALL $@
