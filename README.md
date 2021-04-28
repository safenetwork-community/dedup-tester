# dedup-tester
Bash script which uploads a set of standard files to SAFE Network for performance profiling and investigation of deduplication behaviour

Test files are downloaded from an S3 bucket and are a set of 5, 10, 20, 50, 100, 200MB .zip files

We are only interested in the download performance of these files. Although they have a .zip extension, unzipping them will fail. All we are interested in is the download speed and integrity.
Test files are downloaded as one archive, extracted to a tmp dir and md5 checksums calculated. and compared with the md5sums contained in the download package
Files are then put to the SAFEnetwork and the uploadtimes and xorurls recorded.
After a few hours days, we can download these files again to give us some performance metrics. Also because hopefully many people will run this script we will get some real world tests of deduplication and what performance benefits it will bring as more and more people upload the same set of standard files.

THanks to @MichaelHills for the pointer to these std zip files.



