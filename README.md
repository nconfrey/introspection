# Welcome to Introspection

Learn about your brain by listening to music.
Share and compare snapshots with your friends.

## Requirements

### Download & Install

#### MuseIO and Processing

- [MuseIO](http://developer.choosemuse.com/research-tools/museio)
- [Processing](https://processing.org/)

####liblo, cython, and pyliblo

Steps for OSX with [homebrew](http://brew.sh/) and [pip](https://pypi.python.org/pypi/pip):

```shell
$ brew install liblo
$ pip install cython
$ pip install pyliblo
```

### Move & Install

#### Beads Audio Library

The Beads audio library can be found in [`introspection/src`](https://github.com/nconfrey/introspection/tree/master/src)

**Steps**:

1. Open the processing library folder (found in processing menus under 'preferences')
2. Copy in the library

## Setup

1. Install all requirements
2. Install the Beads audio library
3. Pair the muse
4. Run

## Run

1. Run client:
`$ muse-io --osc osc.udp://localhost:5001`
2. Run the server:
`$ python src/muse/osc_server.py`
3. Run the app from processing


## Troubleshooting

Double check that:

- Everything is running on the appropriate port
- The muse is connected properly (Muse + Laptop bluetooth can be a little temperamental)
- The music file in the Processing sketch actually exists (we did not include the file in this repo)

As of 9/7/15, there are only research tools available for developing for muse + computer. The install steps work for computers running OSX. Some extra work may be necessary to get up and running with Windows or Linux (especially the liblo requirement). 

If you're having trouble with the muse research tools, check [here](http://developer.choosemuse.com/research-tools/getting-started).

If you're having trouble pairing your muse, try forgetting the device from your computer and [resetting the muse](http://dev.choosemuse.com/hardware-firmware/bluetooth-connectivity) and then try pairing again. Usually, it doesn't appear to be connected until the client is running. Quoted from the linked page:

> Factory-reset your Muse. From an off-state, hold the button down for at least 15 seconds until the LEDs begin to flash in an alternating back-and-forth pattern. Then release the button and press it again for about 3 seconds to turn the device off.

Do click the link if you're having further issues with pairing.