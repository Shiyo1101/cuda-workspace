# Pytorch用 Dockerfile
# ベースイメージとしてNVIDIAの公式CUDAイメージを使用
# CUDAのバージョンによっては適宜変更してください
FROM nvidia/cuda:12.2.0-base-ubuntu22.04

# 環境変数の設定
ENV TZ=Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=ja_JP.UTF-8

# 必要なパッケージのインストールと日本語環境の設定
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    python3 \
    python3-pip \
    python3-dev \
    git \
    locales \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 日本語ロケールの設定
RUN locale-gen ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8

# python3 -> pythonへのシンボリックリンク作成
RUN ln -s /usr/bin/python3 /usr/bin/python

# Pythonライブラリのインストール
# README.mdに記載のあった共通ライブラリ + Pytorch
RUN pip install --no-cache-dir \
    torch \
    numpy \
    pandas \
    opencv-python \
    scikit-learn \
    matplotlib \
    scipy \
    ruff

# 作業ディレクトリの作成
WORKDIR /cuda-workspace