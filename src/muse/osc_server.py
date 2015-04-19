from liblo import *
import sys
import time
import signal

to_visualizer_file = "src/simple_processing_visuals/data.txt"
portnum = 5001
update_limit = 5  # number of times callback is called before
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

        self.delta = 0
        self.theta = 0
        self.alpha = 0
        self.beta = 0
        self.gamma = 0
        

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

    def  update_waves(self,d,t,a,b,g):
        if self.num_updates == update_limit:
            self.delta = d
            self.theta = t
            self.alpha = a
            self.beta = b
            self.gamma = g
        else:
            self.num_updates += 1


    def string_acc(self):
        return str(self.acc_x) + ',' + str(self.acc_y) + ',' + str(self.acc_z)

    def string_waves(self):
        vals = [self.delta, self.theta, self.alpha, self.beta, self.gamma]
        return ",".join(map(str,vals))
    

    #receive accelrometer data
    @make_method('/muse/acc', 'fff')
    def acc_callback(self, path, args):
        acc_x, acc_y, acc_z = args
        self.update_acc(acc_x, acc_y, acc_z)
    
    #receive wave data from muse magic black box from EEG
    @make_method('/muse/elements', 'fffff')
    def waves_callback(self, path, args):
        d,t,a,b,g = args
        print "%s %f %f %f %f %f\n" % (path, d,t,a,b,g)
        self.update_waves(d,t,a,b,g)
    

    #handle unexpected messages
    @make_method(None, None)
    def fallback(self, path, args, types, src):
        #actually, just do nothing
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
            f_vis.write(server.string_acc() + ',' + server.string_waves() + '\n')
            server.reset_num_updates()
            f_vis.close()

        #TODO: need an interrupt so that we can quit from the server and close the file

    #close(f_vis)
    sys.exit(0)
