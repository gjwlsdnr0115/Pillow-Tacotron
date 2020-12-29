# Tacotron
Tacotron모델을 이용하여 한국어 TTS를 구현하는 프로젝트입니다.\
본 프로젝트는 Linux/Google Colaboratory 환경에서 구현하였습니다.


Based on
- https://github.com/carpedm20/multi-speaker-tacotron-tensorflow
## Prerequisits
- Python 3.6
- FFmpeg
- Tensorflow 1.3

## Usage
### 1. Install Requirements
나눔고딕 설치
```
apt-get update -qq
apt-get install fonts-nanum* -qq
```
Install Packages
```
pip install tensorflow-gpu==1.3.0
pip install tinytag
pip install jamo
pip install librosa==0.5.1
```
GPU 사용을 위한 Cuda 설치
```
dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
apt-get update
apt-get install cuda=8.0.61-1

dpkg -i "libcudnn6_6.0.21-1+cuda8.0_amd64.deb"
```
### 2. Train Model
Train Multi-Speaker Model
```
python3 train.py --data_path=datasets/kss,datasets/son,datasets/hani
python3 train.py --data_path=datasets/kss,datasets/son,datasets/hani --load_path logs/kss+son+hani
```
### 3. Synthesize Audio
```
python3 synthesizer.py --load_path logs/pretrained --text "안녕하세요" --num_speakers=3 --speaker_id=0
```
## Results
