#!/bin/bash

#Southside 
#April 2021

# script to PUT a series of standard files to exercise the SAFENetwork T5 testnet
#download standard test files from  AWS S3   
#store locally and generate checksums
#compare calculated and downloaded checksums
#upload files and check time elapsed
#upload checksums for each file to ensure we are dealing with standardised test files

DEST_DIR=/tmp/std-file-upload-tests

echo $DEST_DIR
if [[ -d  $DEST_DIR ]]
    then
    rm -rf $DEST_DIR
fi
mkdir $DEST_DIR && cd $DEST_DIR

#Get the files  calculate checksum and write to SAFE Network

#----------------------save on AWS bandwith downloads----comment out the curl line and copy in from local disk
#curl --output dedup-testfiles.zip https://maidsafe-t5-dedup-testfiles.s3-eu-west-1.amazonaws.com/dedup-testfiles.zip

cp /tmp/std-file-resources/testfiles/dedup-testfiles.zip  $DEST_DIR/
#-----------------------------------------------------------------------

unzip dedup-testfiles.zip
#check integrity of downloaded testfiles
 
for i in 5MB 10MB 20MB 50MB 100MB 200MB
    do
        #echo $i
        md5sum $i.zip > calculated-md5-$i.txt
        #ls -l
        cmp md5-$i.txt  calculated-md5-$i.txt
        (($? != 0)) && { printf '%s\n' "Checksums did not match.  Aborting!!"; exit 1; }
        #store files to SAFE Network
        safe files put $i.zip  > $i-location.txt
            #extract Files container address
        safe files put md5-$i.txt
done

exit 0



