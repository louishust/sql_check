#!/bin/bash
if [-d debug]
then
  cd debug
  make && make install
else
  mkdir debug
  cd debug

  cmake -DWITH_DEBUG=1 -DCMAKE_INSTALL_PREFIX=./mysql  -DMYSQL_DATADIR=./mysql/data \
    -DWITH_SSL=yes -DENABLED_LOCAL_INFILE=1 -DWITH_READLINE=1 \
    -DMY_MAINTAINER_CXX_WARNINGS="-Wall -Wextra -Wunused -Wwrite-strings -Wno-strict-aliasing  -Wno-unused-parameter -Woverloaded-virtual" \
    -DMY_MAINTAINER_C_WARNINGS="-Wall -Wextra -Wunused -Wwrite-strings -Wno-strict-aliasing -Wdeclaration-after-statement" \
    ..

  make && make install

  # create default database
  cd mysql/scripts
  ./mysql_install_db --datadir=../data --basedir=../ --user=$whoami

  cd ../../
  cur_path=`pwd`
  echo "[mysqld]
  gdb
  basedir=${cur_path}/mysql/
  datadir=${cur_path}/mysql/data
  socket=${cur_path}/mysql/data/my.sock
  " > ./mysql/my.cnf
fi
