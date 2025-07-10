# CUDA Workspace

このプロジェクトは、NVIDIA GPUを活用したCUDA開発を、DockerとVS Code Dev Containerを用いて簡単に行うための環境です。

-----

## ✅ 前提条件

この開発環境を利用するには、お使いのPC（ホストOS）に以下のソフトウェアがインストールされている必要があります。詳細は次の「環境構築手順」セクションを参照してください。

1.  **NVIDIA ドライバ**
2.  **Docker**
3.  **NVIDIA Container Toolkit** (Linuxのみ)
4.  **Visual Studio Code**
5.  **Dev Containers** (VS Codeの拡張機能)

-----

## 🛠️ 環境構築手順

お使いのオペレーティングシステム（Windows, Mac, Linux）に応じて、手順が一部異なります。

### 1\. NVIDIA ドライバ

  * **説明**: ホストOSがNVIDIA GPUを認識し、DockerコンテナがGPUを利用するために**必須のソフトウェア**です。
  * **インストール**: [NVIDIA公式サイト](https://www.nvidia.co.jp/Download/index.aspx?lang=jp)からお使いのGPUに適合する最新のドライバをダウンロードし、インストールしてください。
  * **確認方法**: ターミナル（WindowsではコマンドプロンプトまたはPowerShell）で以下のコマンドを実行し、GPUの情報が表示されることを確認します。
    ```bash
    nvidia-smi
    ```

> **💡 CUDA Toolkitに関する注意**
> このプロジェクトでは、必要なCUDAライブラリはDockerイメージ内に含まれています。そのため、通常**ホストOSに別途CUDA Toolkitをインストールする必要はありません。** 上記のNVIDIAドライバのインストールが最も重要です。

### 2\. Docker

  * **説明**: コンテナを管理・実行するためのプラットフォームです。
  * **インストール**:
      * **Windows / Mac**: [Docker Desktop](https://www.docker.com/products/docker-desktop/)を公式サイトからダウンロードし、インストールします。
          * **Windowsの注意点**: Docker Desktopは内部でWSL 2 (Windows Subsystem for Linux 2) を使用してGPUをサポートします。インストール中にWSL 2の有効化を求められた場合は、指示に従ってください。
      * **Linux (Ubuntuなど)**: [Docker公式サイトの手順](https://docs.docker.com/engine/install/ubuntu/)に従い、Docker Engineをインストールします。
  * **(Linux限定) 実行権限エラーへの対処**:
    Linuxで`sudo`なしで`docker`コマンドを実行しようとすると、「permission denied」というエラーが発生することがあります。以下のコマンドで現在のユーザーを`docker`グループに追加してください。
    ```bash
    sudo usermod -aG docker $USER
    ```
    **【重要】** このコマンドの実行後、変更を反映させるために一度PCから**ログアウトして再度ログイン**するか、**PCを再起動**する必要があります。
  * **確認方法**: ターミナルで以下のコマンドを実行し、バージョン情報が表示されることを確認します。
    ```bash
    docker --version
    ```

#### 2.1 (必要な場合) プロキシ環境下でのDocker設定

大学や企業のネットワークなど、プロキシサーバを経由してインターネットに接続している場合、Dockerがコンテナイメージをプルしたりビルドしたりするためにプロキシ設定が必要です。

  * **Windows / Mac (Docker Desktop) の場合**

    1.  タスクバー（またはメニューバー）のDockerアイコンを右クリックし、**"Settings"** を開きます。
    2.  **"Resources"** \> **"PROXIES"** に移動します。
    3.  **"Manual proxy configuration"** を選択し、所属する組織から提供されたプロキシサーバの情報を入力します。
          * **Web Server (HTTP):** `http://proxy.example.com:8080`
          * **Secure Web Server (HTTPS):** `http://proxy.example.com:8080`
          * **Bypass for...:** `localhost,127.0.0.1`
    4.  **"Apply & Restart"** ボタンを押して設定を適用します。

  * **Linux の場合**

    1.  `~/.docker/` ディレクトリが存在しない場合は作成します: `mkdir -p ~/.docker/`
    2.  設定ファイル `~/.docker/config.json` をエディタで開きます: `nano ~/.docker/config.json`
    3.  以下の内容をファイルに記述します。ご自身の環境に合わせてプロキシサーバのアドレスとポート、プロキシを使用しないホスト (`noProxy`) を変更してください。
        ```json
        {
         "proxies": {
           "default": {
             "httpProxy": "http://proxy.example.com:8080",
             "httpsProxy": "http://proxy.example.com:8080",
             "noProxy": "localhost,127.0.0.1,docker.io"
           }
         }
        }
        ```
    4.  ファイルを保存し、Dockerサービスを再起動して設定を反映させます。
        ```bash
        sudo systemctl restart docker
        ```

### 3\. NVIDIA Container Toolkit (Linuxのみ)

  * **説明**: **Linuxユーザーのみ**が必要です。Linux上でDockerコンテナがNVIDIA GPUを利用できるようにするためのツールキットです。WindowsやMacではDocker Desktopがこの機能を提供するため、別途インストールは不要です。
  * **インストール (Linux)**: ターミナルで以下のコマンドを実行します。
    ```bash
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo apt-get update
    sudo apt-get install -y nvidia-container-toolkit
    ```
  * **設定の反映 (Linux)**: Toolkitをインストールまたはアップデートした後、Dockerデーモンを再起動して設定を反映させます。
    ```bash
    sudo systemctl restart docker
    ```
  * **確認方法 (Linux)**: 以下のテストコマンドを実行し、エラーなく`nvidia-smi`の出力が表示されれば成功です。
    ```bash
    docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi
    ```

### 4\. Visual Studio Code & Dev Containers拡張機能

  * **説明**: 開発用の高機能エディタと、コンテナ内での開発をシームレスにするための拡張機能です。
  * **インストール**:
    1.  [Visual Studio Code](https://code.visualstudio.com/)を公式サイトからインストールします。
    2.  VS Codeを起動し、左側のアクティビティバーから拡張機能タブを開きます。
    3.  `Dev Containers`と検索し、`ms-vscode-remote.remote-containers`をインストールします。

-----

### 🚀 プロジェクトの起動

すべての前提ソフトウェアの準備が整ったら、以下の手順で開発環境を起動します。

1.  このリポジトリをローカルにクローンし、VS Codeでプロジェクトフォルダを開きます。
    ```bash
    git clone <repository-url>
    cd <repository-directory>
    code .
    ```
2.  VS Codeが`.devcontainer`フォルダを検出し、ウィンドウの右下に\*\*「Reopen in Container」\*\*という通知が表示されます。このボタンをクリックしてください。
3.  自動的にDockerイメージのビルドとコンテナの起動が開始されます。初回は環境構築のため数分かかる場合があります。

ビルドが完了すると、VS Codeのウィンドウがリロードされ、コンテナ内の開発環境に接続された状態になります。左下のステータスバーに「Dev Container: cuda」のように表示されていれば成功です。

-----

### 🔬 動作確認

環境が正しく構築され、コンテナ内からGPUが利用可能かを確認します。

1.  VS Codeでコンテナ内のターミナルを開きます (ショートカット: `Ctrl+J` または `Cmd+J`)。
2.  ターミナルで以下のコマンドを実行します。
    ```bash
    nvidia-smi
    ```
    ホストOSで実行した時と同様のGPU情報が表示されれば、コンテナ内からGPUが正しく認識されています。これで開発の準備は完了です。

-----

### 🐍 Pythonの実行方法

この開発コンテナには、`Dockerfile`に基づきPythonの実行環境がプリインストールされています。

  * **Pythonのバージョン**: `python3`がインストールされ、`python`コマンドで直接呼び出せるように設定されています。

  * **実行方法**:
    VS Codeでコンテナ内のターミナルを開き (`Ctrl+J`)、プロジェクトルート（`/cuda-workspace`）にいることを確認してください。
    `src`フォルダ内に`my_script.py`のようなPythonファイルを作成した場合、以下のコマンドで実行できます。

    ```bash
    python src/my_script.py
    ```

  * **プリインストール済みの主要ライブラリ**:
    Dockerfileの`pip install`コマンドにより、以下のライブラリが利用可能です。

      * `torch`
      * `numpy`
      * `pandas`
      * `opencv-python`
      * `scikit-learn`
      * `matplotlib`
      * `scipy`
      * `ruff`

    もし追加でライブラリが必要になった場合は、コンテナ内のターミナルで`pip install <package-name>`を実行してインストールできます。。
