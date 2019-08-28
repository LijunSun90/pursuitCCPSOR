# AUTHOR: Lijun SUN

# define filename
filename="D20181201_test_encircle_still"

# remove the folder it already exists
rm -rf `echo ${filename}`

# create a folder
mkdir `echo ${filename}`

# step 1 - convert ${filename}.gif to ${filename}-%04d.png
convert `echo ${filename}".gif"` `echo ${filename}"/"``echo ${filename}"-%05d.png"`

# step 2 - convert ${filename}-%04d.png to ${filename}.mp4
ffmpeg -r 8 -i `echo ${filename}"/"``echo ${filename}"-%05d.png"` -qscale 4 `echo ${filename}".mp4"`
