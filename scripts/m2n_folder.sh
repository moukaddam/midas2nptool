#!/bin/bash
set -e
if [ $# -ne 4 ]; then
  printf "Wrong number of argument: usage is m2n_folder configuration.txt path/to/midas/ path/to/root treename\n"
else
  for midas in $2*
  do
    filename=$(basename "$midas")
    froot="${filename%.*}"
    root="$3$froot.root"
    if [ -f $root ] ; then
      printf "\n**** NOTE : File $root already exist, skipping conversion ****\n"
    else
      extension="${filename##*.}"
      check_gz="false"
      if [ $extension == "gz" ]; then
        check_gz="true"
        printf "\n**** Decompressing file $filename ****\n"
        gzip -d $2/$filename
        filename="${filename%.*}"
      else
        filename="${filename%.*}"
      fi

      midas2nptool $1 $2$filename $root $4
      if [ $check_gz == "true" ]; then
        printf "\n**** Recompressing file $filename ****\n"
        gzip $2/$filename
      fi
    fi
  done
fi
