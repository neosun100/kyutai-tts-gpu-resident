from fastmcp import FastMCP
import torch
import numpy as np
import sphn
import tempfile
from moshi.models.loaders import CheckpointInfo
from moshi.models.tts import DEFAULT_DSM_TTS_REPO, DEFAULT_DSM_TTS_VOICE_REPO, TTSModel
from gpu_manager import gpu_manager
import os

mcp = FastMCP("Kyutai-TTS")

DEVICE = os.getenv('DEVICE', 'cuda')
HF_REPO = os.getenv('HF_REPO', DEFAULT_DSM_TTS_REPO)
VOICE_REPO = os.getenv('VOICE_REPO', DEFAULT_DSM_TTS_VOICE_REPO)
DEFAULT_VOICE = 'expresso/ex03-ex01_happy_001_channel1_334s.wav'

def load_model():
    checkpoint_info = CheckpointInfo.from_hf_repo(HF_REPO)
    return TTSModel.from_checkpoint_info(checkpoint_info, n_q=32, temp=0.6, device=DEVICE)

@mcp.tool()
def text_to_speech(
    text: str,
    output_path: str,
    voice: str = DEFAULT_VOICE,
    cfg_coef: float = 2.0
) -> dict:
    """
    Convert text to speech using Kyutai TTS
    
    Args:
        text: Text to synthesize
        output_path: Path to save the audio file (must end with .wav)
        voice: Voice name (default: expresso/ex03-ex01_happy_001_channel1_334s.wav)
        cfg_coef: CFG coefficient (1.0-3.0, default: 2.0)
    
    Returns:
        Result dictionary with status and output path
    """
    try:
        tts_model = gpu_manager.get_model(load_model)
        entries = tts_model.prepare_script([text], padding_between=1)
        voice_path = tts_model.get_voice_path(voice) if not voice.endswith('.safetensors') else voice
        condition_attributes = tts_model.make_condition_attributes([voice_path], cfg_coef=cfg_coef)
        
        result = tts_model.generate([entries], [condition_attributes])
        
        with tts_model.mimi.streaming(1), torch.no_grad():
            pcms = []
            for frame in result.frames[tts_model.delay_steps:]:
                pcm = tts_model.mimi.decode(frame[:, 1:, :]).cpu().numpy()
                pcms.append(np.clip(pcm[0, 0], -1, 1))
            pcm = np.concatenate(pcms, axis=-1)
        
        sphn.write_wav(output_path, pcm, tts_model.mimi.sample_rate)
        gpu_manager.force_offload()
        
        return {
            'status': 'success',
            'output_path': output_path,
            'duration_seconds': len(pcm) / tts_model.mimi.sample_rate
        }
    except Exception as e:
        gpu_manager.force_offload()
        return {'status': 'error', 'error': str(e)}

@mcp.tool()
def get_gpu_status() -> dict:
    """
    Get GPU status and memory usage
    
    Returns:
        GPU status information
    """
    if torch.cuda.is_available():
        return {
            'available': True,
            'model_loaded': gpu_manager.model is not None,
            'memory_used_gb': round(torch.cuda.memory_allocated() / 1024**3, 2),
            'memory_total_gb': round(torch.cuda.get_device_properties(0).total_memory / 1024**3, 2)
        }
    return {'available': False}

@mcp.tool()
def offload_gpu() -> dict:
    """
    Force offload model from GPU to free memory
    
    Returns:
        Status message
    """
    gpu_manager.force_offload()
    return {'status': 'GPU memory released'}

if __name__ == "__main__":
    mcp.run()
