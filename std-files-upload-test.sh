#!/bin/bash

#Southside 
#April 2021

# script to PUT a series of standard files to exercise the SAFENetwork T5 testnet
#download standard test files from  AWS S3   
#store locally and generate checksums
#compare calculated and downloaded checksums
#upload files to SAFE Network and check time elapsed
#upload checksums for each file to ensure we are dealing with standardised test files


#period of time to wait  before attempting to retreive the files
DELAY=60


mkdir /tmp/std-file-uploads-test
DEST_DIR=/tmp/std-file-uploads-test/$(date +%Y%m%d_%H%M%S)
PATH=$PATH:/home/$USER/.safe/cli         # This should not be needed
#safe auth restart
#safe auth create --test-coins
OPEN_BALANCE=`safe keys balance| safe keys balance|tail -n1|cut -f2 -d':'`

echo "==============================================================="
echo ""
echo "output files will be written to " $DEST_DIR
echo ""
echo "This account has a balance of "$OPEN_BALANCE
echo "==============================================================="


if [[ -d  $DEST_DIR ]]
    then
    rm -rf $DEST_DIR
fi
mkdir -p $DEST_DIR && cd $DEST_DIR
#pwd
#Get the files  calculate checksum and write to SAFE Network

#----------------------save on AWS bandwith downloads----comment out the curl line and copy in from local disk
#curl --output dedup-testfiles.zip https://maidsafe-t5-dedup-testfiles.s3-eu-west-1.amazonaws.com/dedup-testfiles.zip

cp /home/$USER/tmp/testfiles/dedup-testfiles.zip  $DEST_DIR/
#-----------------------------------------------------------------------
touch safe-xorurl.txt
unzip dedup-testfiles.zip >/dev/null

for i in 5MB 10MB #20MB #50MB 100MB 200MB   #commented out for speed up dev and test
    do
        echo ""
        echo "processing a "$i" standard testfile"
        echo ""
        #check integrity of downloaded testfiles
        md5sum $i.zip > calculated-md5-$i.txt
        cmp md5-$i.txt  calculated-md5-$i.txt
        (($? != 0)) && { printf '%s\n' "Checksums did not match.  Aborting!!"; exit 1; }
        #store files to SAFE Network and extract testfiles xorurl address
        time safe files put $i.zip |  cut -f2 -d'"'  >> safe-xorurl.txt
        # /home/$USER/.safe/cli/
        safe files put md5-$i.txt >>/dev/null
done


CLOSE_BALANCE=`safe keys balance|tail -n1|cut -f2 -d':'`
echo ""
echo "========================================================================================"
echo ""
echo "cost of storage was " $(($OPEN_BALANCE-$CLOSE_BALANCE))
echo ""
echo "sleeping for "$DELAY" seconds"
sleep $DELAY


#---------------------rtreive files-----------------

cat safe-xorurl.txt
cat safe-xorurl.txt | while read container
do
    safe files get safe://$container

done

echo  "TODO      thanks for using this tool  - more to come"
echo ""
echo "That's All, Folks!!"



exit 0








