# ベースイメージとして TensorFlow GPU イメージを使用（CUDA 12.2 対応）
FROM tensorflow/tensorflow:2.13.0-gpu

# 環境変数の設定
ENV TZ=Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=ja_JP.UTF-8

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 日本語ロケールの設定
RUN locale-gen ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8

# python3 -> pythonへのシンボリックリンク作成
RUN ln -s /usr/bin/python3 /usr/bin/python

# Pythonライブラリのインストール
RUN pip install --no-cache-dir \
    Pillow \
    numpy \
    tensorflow \
    keras \
    scikit-learn \
    scikit-image \
    ruff

# 環境変数の設定（CUDA関係）
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# 作業ディレクトリの作成
WORKDIR /cuda-workspace

# コンテナ起動時にシェルを開く設定
CMD ["bash"]