#echo "param0: $0"
#echo "param1: $1"
#echo "param2: $2"

target_rep=$1
max_fragment_size=$2
base_url=$3

# constants
header_referer="referer: https://www.hotstar.com/"
header_user_agent="user-agent: Mozilla/5  AppleWebKit/537 Chrome/78 Safari/537"


if [ "x$base_url" == "x" ] 
then
echo "Missing base URL"
exit 0
fi

if [ "x$target_rep" == "x" ] 
then
target_rep="1"
echo "Choosing default representation : $target_rep"
fi

if [ "x$max_fragment_size" == "x" ] 
then
max_fragment_size=1000
echo "Choosing max fragment size : $max_fragment_size"
else
max_fragment_size=expr $max_fragment_size + 0
echo "Fragment size : $max_fragment_size"
fi



video_rep="video/avc1/$target_rep"
audio_rep="audio/und/mp4a/$target_rep"

mkdir video
mkdir video/avc1
mkdir video/avc1/$target_rep

mkdir audio
mkdir audio/und
mkdir audio/und/mp4a
mkdir audio/und/mp4a/$target_rep

echo "Directories made : $video_rep"
echo "Directories made : $audio_rep"


# Video init file
video_init_url="$base_url/$video_rep/init.mp4"

curl --url "$video_init_url" --output "$video_rep/init.mp4" -H "$header_referer" -H "$header_user_agent"
echo "Video Init downloaded : $video_rep/init.mp4"

# Audio init file
audio_init_url="$base_url/$audio_rep/init.mp4"
curl --url "$audio_init_url" --output "$audio_rep/init.mp4" -H "$header_referer" -H "$header_user_agent"
echo "Audio Init downloaded : $audio_rep/init.mp4"

for number in $(seq 1 $max_fragment_size);
do
 #video fragments
 url="$base_url/$video_rep/seg-$number.m4s"
 curl --url "$url" --output "$video_rep/seg-$number.m4s" -H "$header_referer" -H "$header_user_agent"
 echo "Video downloaded : $video_rep/seg-$number.m4s"

 #audio fragments
 url="$base_url/$audio_rep/seg-$number.m4s"
 curl --url "$url" --output "$audio_rep/seg-$number.m4s" -H "$header_referer" -H "$header_user_agent"
 echo "Audio downloaded : $audio_rep/seg-$number.m4s"
done



