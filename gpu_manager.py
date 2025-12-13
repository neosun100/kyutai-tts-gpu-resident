import threading
import time
import torch
import os

class GPUManager:
    def __init__(self, idle_timeout=60):
        self.model = None
        self.last_used = time.time()
        self.idle_timeout = int(os.getenv('GPU_IDLE_TIMEOUT', idle_timeout))
        self.lock = threading.Lock()
        self._monitor_thread = threading.Thread(target=self._monitor, daemon=True)
        self._monitor_thread.start()

    def get_model(self, load_func):
        with self.lock:
            if self.model is None:
                self.model = load_func()
            self.last_used = time.time()
            return self.model

    def force_offload(self):
        with self.lock:
            if self.model is not None:
                del self.model
                self.model = None
                torch.cuda.empty_cache()

    def _monitor(self):
        while True:
            time.sleep(10)
            with self.lock:
                if self.model is not None and (time.time() - self.last_used) > self.idle_timeout:
                    del self.model
                    self.model = None
                    torch.cuda.empty_cache()

gpu_manager = GPUManager()
