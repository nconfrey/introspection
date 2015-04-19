import liblo
import sys
import time
from osc_server_thread import MuseServer

# create server, listening on port 1234
try:
    server = liblo.MuseServer()
except liblo.ServerError, err:
    print str(err)
    sys.exit()

def muse_acc_callback(path, args):
    acc_x, acc_y, acc_z = args
    print "received message '%s' with arguments '%f' '%f' and '%f'" % (path, acc_x, acc_y, acc_z)

def muse_eeg_callback(path, args):
    l_ear, l_forhead, r_forhead, r_ear = args
    print "received message '%s' with arguments '%f' '%f' '%f' and '%f'" % (path, l_ear, l_forhead, r_forhead, r_ear)
    #print "blob contains %d bytes, user data was '%s'" % (len(args[0]), data)

def fallback(path, args, types, src):
    print "got unknown message '%s' from '%s'" % (path, src.url)
    for a, t in zip(args, types):
        print "argument of type '%s': %s" % (t, a)

# register method taking an int and a float
server.add_method("/foo/acc", 'fff', muse_acc_callback)

# register method taking a blob, and passing user data to the callback
server.add_method("/foo/eeg", 'ffff', muse_eeg_callback)

# register a fallback for unhandled messages
server.add_method(None, None, fallback)

# loop and dispatch messages every 100ms
while True:
    server.recv(100)