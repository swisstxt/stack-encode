# Stack Encode

[![Gem Version](https://badge.fury.io/rb/stack-encode.svg)](http://badge.fury.io/rb/stack-encode)

A simple gem for automating the encoding process with ffmpeg.

## Installation

    $ gem install stack-encode

## Usage

See the help screen:

```bash
$ stack-encode help

stack-encode commands:
  stack-encode encode FILES    # Encodes a number video or audio files
  stack-encode help [COMMAND]  # Describe available commands or one specific command
  stack-encode version         # Outputs the version number
```

Example encode command:

```bash
$ stack-encode encode -d ~/destination/ /source/files/*
Encoding 2011-05-31_0053_lo.mpg to MP4:	    [#################################] 100%
Encoding 2011-05-31_0053_loaud3.mp2 to MP3:	[#################################] 100%
Encoding 2011-05-31_0053_loaud4.mp2 to MP3:	[#################################] 100%
Encoding 2014-05-26_0010_lo.mp4 to MP4:	    [#################################] 100%
```

## Profiles

Stack Encode supports ffmpeg setting profiles in the form of YAML files.
There are 3 different hashes for the following settings:

  - video settings - used for transcoding video files
  - audio settings - used for transcoding audio files
  - transcoder settings - general transcoder settings

This is an example profile file for stack-encode (my_profile.yml):

```YAML
---
video:
  resolution: 320x480
  frame_rate: 10
  x264_vprofile: high
  x264_preset: slow
  audio_codec: libfaac
  custom: -movflags +faststart

audio:
  audio_channels: 1
  custom: -ab 48k

transcoder:
  preserve_aspect_ratio: :width
```
You can use the profile from above like this:

```bash
$ stack-encode encode --profile my_profile.yml audio_file.wma
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
