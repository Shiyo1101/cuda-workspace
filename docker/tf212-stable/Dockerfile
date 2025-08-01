# ベースイメージとして TensorFlow GPU イメージを使用（CUDA 12.2 対応）
FROM tensorflow/tensorflow:2.12.0-gpu

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Pythonライブラリのインストール
RUN pip install --no-cache-dir \
    Pillow \
    opencv-python \
    numpy \
    tensorflow \
    scikit-learn \
    scikit-image \
    ruff

# 環境変数の設定（CUDA関係）
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# 作業ディレクトリの作成
WORKDIR /cuda-workspace

# コンテナ起動時にシェルを開く設定
CMD ["bash"]