#!/bin/bash

# read input line, get youtube_url
# use yt-dlp -x --audio-format wav ${youtube_url} download the audio of this youtube video
# example: yt-dlp -x --audio-format wav https://www.youtube.com/watch?v=KzfQhc9OEog

youtube_url=$1
title=$2

if [ -z "$title" ]; then
    title=`yt-dlp -x --audio-format wav --print title ${youtube_url}`
fi

yt-dlp -x --audio-format wav --postprocessor-args "-ar 16000" -o $title -P result/${title} ${youtube_url}

# ./main -m models/ggml-large-v1.bin -otxt true -l zh -f ${file_path} transcript audio to txt

./main -m models/ggml-large-v1.bin -otxt true -l zh -f result/${title}/${title}.wav