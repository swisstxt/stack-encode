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
  stack-encode version         # Outputs the version
```

Example encode command:

```bash
$ stack-encode encode -d ~/destination/ /source/files/*
Trancoding 2011-05-31_0053_lo.mpg to Mp4:	    [#################################] 100%
Trancoding 2011-05-31_0053_loaud3.mp2 to Mp3:	[#################################] 100%
Trancoding 2011-05-31_0053_loaud4.mp2 to Mp3:	[#################################] 100%
Trancoding 2014-05-26_0010_lo.mp4 to Mp4:	    [#################################] 100%
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
