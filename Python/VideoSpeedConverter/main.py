import sys
import ffmpeg

input_file, output_file, speed_factor = sys.argv[1:]

input = ffmpeg.input(input_file)
# ------------------------------

audio = input.audio.filter("atempo", float(speed_factor))
video = input.video.setpts(f"{1/float(speed_factor)}*PTS")

# ------------------------------
output = ffmpeg.output(audio, video, output_file)
ffmpeg.run(output)
