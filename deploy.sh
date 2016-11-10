#! /bin/bash

git add -A .

if [ -z $1 ];
then
	echo "1st arg required"

else
	git commit -m "$1"
fi

git push
