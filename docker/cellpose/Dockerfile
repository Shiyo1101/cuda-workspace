# Cellpose用 Dockerfile
# Cellpose参考：https://github.com/MouseLand/cellpose

# ベースイメージとしてNVIDIAの公式CUDAイメージを使用
# CUDAのバージョンによっては適宜変更してください
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

# 環境変数の設定
ENV TZ=Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=ja_JP.UTF-8
ENV DISPLAY=""
ENV QT_QPA_PLATFORM=offscreen

# 必要なパッケージのインストールと日本語環境の設定
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    python3 \
    python3-pip \
    python3-dev \
    git \
    locales \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 日本語ロケールの設定
RUN locale-gen ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8

# python3 -> pythonへのシンボリックリンク作成
RUN ln -s /usr/bin/python3 /usr/bin/python

# Pythonライブラリのインストール
RUN pip install --no-cache-dir \
    cellpose \
    opencv-python \
    matplotlib \
    ruff

# 作業ディレクトリの作成
WORKDIR /cuda-workspace