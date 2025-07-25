# Conda-Tensorflow用 Dockerfile (TensorFlow 2.17対応)
# ベースイメージとしてNVIDIAの公式CUDAイメージを使用
FROM nvidia/cuda:12.2.0-base-ubuntu22.04

# 環境変数の設定
ENV TZ=Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=ja_JP.UTF-8
# Condaのパスを通す
ENV PATH /opt/conda/bin:$PATH

# 必要なパッケージのインストールと日本語環境の設定
# Condaのインストーラーを実行するためにwgetを追加
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    python3 \
    python3-pip \
    python3-dev \
    git \
    locales \
    wget \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 日本語ロケールの設定
RUN locale-gen ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8

# Miniconda (Condaの軽量版) のインストール
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    conda clean -afy

# CondaでTensorFlow 2.17と主要なPythonライブラリをインストール
# TensorFlow 2.17はCUDA 12.3とcuDNN 8.9を要求する
RUN conda install -c conda-forge -y \
    python=3.10 \
    tensorflow=2.17 \
    cudatoolkit=12.3 \
    cudnn=8.9 \
    numpy \
    pandas \
    opencv \
    scikit-learn \
    matplotlib \
    scipy \
    ruff

# 作業ディレクトリの作成
WORKDIR /cuda-workspace