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

# ユーザー作成（NIS環境対応）
ARG USER_UID="enter you are uid. if check own uid, run command: echo $uid"
ARG USER_GID="enter you are gid. if check own gid, run command: echo $gid"
ARG USERNAME="enter you are username. if check own username, run command: whoami"

# グループが存在しない場合は作成
RUN groupadd -f -g ${USER_GID} ${USERNAME} || true

# ユーザーを作成
RUN useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash ${USERNAME} || \
    usermod -u ${USER_UID} -g ${USER_GID} ${USERNAME}

# sudoをインストールして権限を付与（必要に応じて）
RUN apt-get update && apt-get install -y sudo && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}