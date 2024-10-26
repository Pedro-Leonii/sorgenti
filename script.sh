
cp -r src/* dst

for f in $DIR_TO_DEL
do
  rm -r dst/$f
done

find dst/* -type f ! -name "*.pdf" -delete

ls dst
