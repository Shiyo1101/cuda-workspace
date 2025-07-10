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

### ✨ プロジェクトの特長

  - **コンテナ化された開発環境**: 開発に必要なライブラリやツールはすべてDockerコンテナ内にパッケージ化されているため、ローカル環境を汚しません。
  - **GPUサポート**: コンテナ内からNVIDIA GPUを直接利用可能です。
  - **VS Codeとの完全統合**:
      - **推奨拡張機能**: Python開発、Docker連携、Git管理などを快適にするためのVS Code拡張機能が自動的にインストールされます。
      - **リンターとフォーマッター**: [Ruff](https://github.com/astral-sh/ruff) を利用したコーディング規約のチェックとコードの自動整形が設定されています。
      - **保存時の自動整形**: Pythonファイルを保存すると、自動で`import`の整理とコードのフォーマットが実行されます。