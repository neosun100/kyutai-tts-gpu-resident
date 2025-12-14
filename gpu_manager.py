import threading
import torch

class GPUManager:
    def __init__(self):
        self.model = None
        self.lock = threading.Lock()

    def get_model(self, load_func):
        with self.lock:
            if self.model is None:
                self.model = load_func()
            return self.model

    def force_offload(self):
        with self.lock:
            if self.model is not None:
                del self.model
                self.model = None
                torch.cuda.empty_cache()

gpu_manager = GPUManager()
