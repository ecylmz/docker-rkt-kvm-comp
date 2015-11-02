echo "-----`date`-----" >> results/rkt.log
sudo rkt -insecure-skip-verify run stream-latest.aci >> results/rkt.log
