#!/bin/bash

#Southside 
#April 2021

# script to PUT a series of standard files to exercise the SAFENetwork T5 testnet
#download standard test files from  AWS S3   
#store locally and generate checksums
#compare calculated and downloaded checksums
#upload files to SAFE Network and check time elapsed
#upload checksums for each file to ensure we are dealing with standardised test files

DEST_DIR=/tmp/std-file-upload-tests-02
PATH=$PATH:/home/$USER/.safe/cli

echo "output files will be written to " $DEST_DIR
if [[ -d  $DEST_DIR ]]
    then
    rm -rf $DEST_DIR
fi
mkdir -p $DEST_DIR && cd $DEST_DIR
#pwd
#Get the files  calculate checksum and write to SAFE Network

#----------------------save on AWS bandwith downloads----comment out the curl line and copy in from local disk
curl --output dedup-testfiles.zip https://maidsafe-t5-dedup-testfiles.s3-eu-west-1.amazonaws.com/dedup-testfiles.zip

#cp /home/$USER/tmp/testfiles/dedup-testfiles.zip  $DEST_DIR/
#-----------------------------------------------------------------------
touch safe-xorurl.txt
unzip dedup-testfiles.zip >/dev/null

for i in 5MB 10MB 20MB #50MB 100MB 200MB   #commented out for speed up dev and test
    do
        echo "processing a " $i " standard testfile"
        #check integrity of downloaded testfiles
        md5sum $i.zip > calculated-md5-$i.txt
        cmp md5-$i.txt  calculated-md5-$i.txt
        (($? != 0)) && { printf '%s\n' "Checksums did not match.  Aborting!!"; exit 1; }
        #store files to SAFE Network and extract testfiles xorurl address
        time safe files put $i.zip | tail -c61  >> safe-xorurl.txt
        # /home/$USER/.safe/cli/
        safe files put md5-$i.txt
done
cat safe-xorurl.txt
exit 0





