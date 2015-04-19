from liblo import *
import sys
import time
import signal

to_visualizer_file = "data"
portnum = 5001
update_limit = 25  # number of times callback is called before
                    # actually updating and returning any info
sleep_time = .25 #change to write faster
running = 1

def signal_handler(signal, frame):
    running = 0


class MuseServer(ServerThread):
    #listen for messages on port portnum
    def __init__(self):
        ServerThread.__init__(self, portnum)

        self.acc_x = 0
        self.acc_y = 0
        self.acc_z = 0

        self.l_ear = 0
        self.l_forehead = 0
        self.r_forehead = 0
        self.r_ear = 0

        # we keep track of the number of times callbacks called 
        # because we don't want ALL of the data because it's too much
        self.num_updates = 0

    def reset_num_updates(self):
        self.num_updates = 0

    def update_acc(self,x,y,z):
        if self.num_updates == update_limit:
            self.acc_x = x
            self.acc_y = y
            self.acc_z = z
        else:
            self.num_updates += 1

    def update_eeg(self, l_e, l_f, r_f, r_e):
        if self.num_updates == update_limit:
            self.l_ear = l_e
            self.l_forehead = l_f
            self.r_forehead = r_f
            self.r_ear = r_e
        else:
            self.num_updates += 1

    def string_acc(self):
        return str(self.acc_x) + ',' + str(self.acc_y) + ',' + str(self.acc_z)

    def string_eeg(self):
        vals = [self.l_ear, self.l_forehead, self.r_forehead, self.r_ear]
        return ",".join(map(str,vals))

    #receive accelrometer data
    @make_method('/muse/acc', 'fff')
    def acc_callback(self, path, args):
        acc_x, acc_y, acc_z = args
        #print "%s %f %f %f" % (path, acc_x, acc_y, acc_z)
        self.update_acc(acc_x, acc_y, acc_z)
    
    #receive EEG data
    @make_method('/muse/eeg', 'ffff')
    def eeg_callback(self, path, args):
        l_ear, l_forehead, r_forehead, r_ear = args
        #print "%s %f %f %f %f" % (path, l_ear, l_forehead, r_forehead, r_ear)
        self.update_eeg(l_ear, l_forehead, r_forehead, r_ear)
    

    #handle unexpected messages
    @make_method(None, None)
    def fallback(self, path, args, types, src):
        """
        print "Unknown message \
		\n\t Source: '%s' \
		\n\t Address: '%s' \
		\n\t Types: '%s ' \
		\n\t Payload: '%s'" \
		% (src.url, path, types, args)
        """

try:
    server = MuseServer()
except ServerError, err:
    print str(err)
    sys.exit()

server.start()

if __name__ == "__main__":
    #f_vis = open(to_visualizer_file, 'w')

    while running:
        #signal.signal(signal.SIGINT, signal_handler)
        time.sleep(sleep_time)
        if server.num_updates == update_limit:
            print "writing\n"
            f_vis = open(to_visualizer_file, 'w')
            f_vis.write(server.string_acc() + ',' + server.string_eeg())
            server.reset_num_updates()
            f_vis.close()

        #TODO: need an interrupt so that we can quit from the server and close the file

    #close(f_vis)
    sys.exit(0)
