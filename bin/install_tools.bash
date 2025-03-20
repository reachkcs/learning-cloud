#!/bin/bash
TOOLS_DIR=~/kcs-tools
TARGET_BIN_DIR=${TOOLS_DIR}/bin
TARGET_SQL_DIR=${TOOLS_DIR}/sql

if [ -d ${TOOLS_DIR} ];then
  echo "ERROR: ${TOOLS_DIR} already exists!"
  exit 0
fi
mkdir -p ${TOOLS_DIR}

cd ..
pwd
SOURCE_BIN_DIR=`pwd`/bin
SOURCE_SQL_DIR=`pwd`/sql

ln -s ${SOURCE_BIN_DIR} ${TARGET_BIN_DIR}
ln -s ${SOURCE_SQL_DIR} ${TARGET_SQL_DIR}

echo "export TOOLS_DIR=${TOOLS_DIR}" >> ~/.bashrc
echo 'export PATH=${TOOLS_DIR}/bin:${PATH}' >> ~/.bashrc
echo "Please resource ~/.bashrc before using the tool"
