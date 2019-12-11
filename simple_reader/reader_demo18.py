# Simple example to read data with psana2
# 

import sys

import os
from psana import DataSource

import numpy as np
import time
from mpi4py import MPI

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()


xtc_dir = os.path.join(os.getenv('TEST_XTC_DIR'))
print(xtc_dir)


st = MPI.Wtime()
ds = DataSource(exp='xpptut13', run=1, dir=xtc_dir, batch_size=10, max_events=100)

ds_done_t = MPI.Wtime()

comm.Barrier()
ds_called_ts = time.time()
barrier_t = MPI.Wtime()

sendbuf = np.zeros(1, dtype='i')
if rank == 0:
    recvbuf = np.zeros([size, 1], dtype='i')
else:
    recvbuf = None

for run in ds.runs():
    det = run.Detector('cspad')

    for evt in run.events():
        sendbuf += 1
        photon_energy = det.raw.photonEnergy(evt)
        raw = det.raw.raw(evt)
        print("event", evt.timestamp, len(raw), photon_energy, raw.shape)

run_done_t = MPI.Wtime()

comm.Gather(sendbuf, recvbuf, root=0)
en = MPI.Wtime()

if rank == 0:
    n_events = np.sum(recvbuf)
    evtbuilder = int(os.environ.get('PS_SMD_NODES', 1))
    print (f'#eb: {evtbuilder} total(s): {en-st:.2f} rate(kHz): {n_events/((en-st)*1000):.2f} n-events: {n_events} '
           f'ds(s): {ds_done_t-st:.2f} barrier(s): {barrier_t-ds_done_t:.2f} '
           f'run(s): {run_done_t-barrier_t:.2f} gather(s): {en-run_done_t:.2f} ds_called: {ds_called_ts:.0f}')
    print(recvbuf)
    
