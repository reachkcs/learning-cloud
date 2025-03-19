#!/bin/bash
TOOL_DIR=~/kcs-tools
TARGET_BIN_DIR=${TOOL_DIR}/bin
TARGET_SQL_DIR=${TOOL_DIR}/sql

if [ -d ${TOOL_DIR} ];then
  echo "ERROR: ${TOOL_DIR} already exists!"
  exit 0
fi
mkdir -p ${TOOL_DIR}

cd ..
pwd
SOURCE_BIN_DIR=`pwd`/bin
SOURCE_SQL_DIR=`pwd`/sql

ln -s ${SOURCE_BIN_DIR} ${TARGET_BIN_DIR}
ln -s ${SOURCE_SQL_DIR} ${TARGET_SQL_DIR}

echo "export TOOL_DIR=${TOOL_DIR}" >> ~/.bashrc
echo 'export PATH=${TOOL_DIR}/bin:${PATH}' >> ~/.bashrc
echo "Please resource ~/.bashrc before using the tool"
