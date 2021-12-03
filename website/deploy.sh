#!/bin/bash

# Deploy script for Hugo website
hugo
scp -r public/* kguay_kevinguay@ssh.phx.nearlyfreespeech.net:/home/public

#hugo && rsync -avz --delete public/ www-data@www.kevinguay.com:/var/www/html/www.minimalistprogrammer.io

exit 0
