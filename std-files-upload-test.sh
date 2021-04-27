#Southside
# 
#April 2021

#trivial script to  put a series of files to exercise the SAFENetwork T5 testnet
#download standard test files from     https://www.thinkbroadband.com/download 
#store locally and generate checksums
# upload files and check time elapsed
#upload checksums for each file



#Setup
rm -rf /tmp/std-file-upload-tests
mkdir /tmp/std-file-upload-tests
cd /tmp/std-file-upload-tests




#Get the files  calculate checksum and write to SAFE Network
for i in 5MB 10MB 20MB 50MB 100MB 200MB 512MB
    do
    curl --output $i.zip http://ipv4.download.thinkbroadband.com:8080/$i.zip
    ls -l $i.zip
    md5sum $i.zip > md5-$i.txt
    safe files put $i.zip
    safe files put md5-$i.txt
done















exit 0