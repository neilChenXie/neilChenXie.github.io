#! /bin/bash

if [ -z $1 ];
then
	echo "1st arg required"

else
	rm -r ./css ./js ./_includes ./_layouts 
	cp -r ../$1/css ../$1/js ../$1/_includes ../$1/_layouts ../$1/sync.sh ./

	git add -A .
	git commit -m "Change Layout"
	git push
fi

