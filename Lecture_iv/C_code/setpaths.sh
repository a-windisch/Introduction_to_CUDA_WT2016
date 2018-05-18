#!/bin/bash
if grep -q '# set paths for openmpi' ~/.bashrc;then
  echo "Path has already been added."
  echo "Nothing to do."
 else
  echo '# ' >> ~/.bashrc
  echo '# set paths for openmpi ' >> ~/.bashrc
  echo '# ' >> ~/.bashrc
  echo 'PATH=$PATH:/opt/openmpi/bin; export PATH' >> ~/.bashrc
  echo 'LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/openmpi/lib' >> ~/.bashrc
  echo '# ' >> ~/.bashrc
  bash
fi

