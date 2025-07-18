# CUDA Workspace

このプロジェクトは、NVIDIA GPU を活用した Python 開発環境を、Docker と VS Code Dev Container を用いて簡単にセットアップするためのリポジトリです。
機械学習プロジェクトのテンプレートにご活用ください。

---

## ✅ 前提条件

この開発環境を利用するには、お使いの PC（ホスト OS）に以下のソフトウェアがインストールされている必要があります。詳細は次の「環境構築手順」セクションを参照してください。

1. **NVIDIA ドライバ**
2. **Docker**
3. **NVIDIA Container Toolkit** (Linux のみ)
4. **Visual Studio Code**
5. **Dev Containers** (VS Code の拡張機能)

---

## 🛠️ 環境構築手順

お使いのオペレーティングシステム（Windows, Mac, Linux）に応じて、手順が一部異なります。

### 1\. NVIDIA ドライバ

- **説明**: ホスト OS が NVIDIA GPU を認識し、Docker コンテナが GPU を利用するために**必須のソフトウェア**です。
- **インストール**: [NVIDIA 公式サイト](https://www.nvidia.co.jp/Download/index.aspx?lang=jp)からお使いの GPU に適合する最新のドライバをダウンロードし、インストールしてください。
- **確認方法**: ターミナル（Windows ではコマンドプロンプトまたは PowerShell）で以下のコマンドを実行し、GPU の情報が表示されることを確認します。

  ```bash
  nvidia-smi
  ```

> [!WARNING]
> **💡 CUDA Toolkit に関する注意**
> このプロジェクトでは、必要な CUDA ライブラリは Docker イメージ内に含まれています。そのため、通常ホスト OS に別途 CUDA Toolkit をインストールする必要はありません。上記の NVIDIA ドライバのインストールが最も重要です。

### 2\. Docker

- **説明**: コンテナを管理・実行するためのプラットフォームです。
- **インストール**:

  - **Windows / Mac**: [Docker Desktop](https://www.docker.com/products/docker-desktop/)を公式サイトからダウンロードし、インストールします。
    - **Windows の注意点**: Docker Desktop は内部で WSL 2 (Windows Subsystem for Linux 2) を使用して GPU をサポートします。インストール中に WSL 2 の有効化を求められた場合は、指示に従ってください。
  - **Linux (Ubuntu など)**: [Docker 公式サイトの手順](https://docs.docker.com/engine/install/ubuntu/)に従い、Docker Engine をインストールします。

    ```bash
    # curl のインストール
    sudo apt-get update && sudo apt-get install -y curl

    # インストールシェルスクリプトのダウンロード & 実行
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh ./get-docker.sh
    ```

- **(Linux 限定) 実行権限エラーへの対処**:
  Linux で`sudo`なしで`docker`コマンドを実行しようとすると、「permission denied」というエラーが発生することがあります。以下のコマンドで現在のユーザーを`docker`グループに追加してください。

  ```bash
  sudo usermod -aG docker $USER
  ```

  **【重要】** このコマンドの実行後、変更を反映させるために一度 PC から**ログアウトして再度ログイン**するか、**PC を再起動**する必要があります。

- **確認方法**: ターミナルで以下のコマンドを実行し、バージョン情報が表示されることを確認します。

  ```bash
  docker --version
  ```

#### 2.1 (必要な場合) プロキシ環境下での Docker 設定

大学や企業のネットワークなど、プロキシサーバを経由してインターネットに接続している場合、Docker がコンテナイメージをプルしたりビルドしたりするためにプロキシ設定が必要です。

- **Windows / Mac (Docker Desktop) の場合**

  1. タスクバー（またはメニューバー）の Docker アイコンを右クリックし、**"Settings"** を開きます。
  2. **"Resources"** \> **"PROXIES"** に移動します。
  3. **"Manual proxy configuration"** を選択し、所属する組織から提供されたプロキシサーバの情報を入力します。
     - **Web Server (HTTP):** `http://proxy.example.com:8080`
     - **Secure Web Server (HTTPS):** `http://proxy.example.com:8080`
     - **Bypass for...:** `localhost,127.0.0.1`
  4. **"Apply & Restart"** ボタンを押して設定を適用します。

- **Linux の場合**

  1. `~/.docker/` ディレクトリが存在しない場合は作成します: `mkdir -p ~/.docker/`
  2. 設定ファイル `~/.docker/config.json` をエディタで開きます: `nano ~/.docker/config.json`
  3. 以下の内容をファイルに記述します。ご自身の環境に合わせてプロキシサーバのアドレスとポート、プロキシを使用しないホスト (`noProxy`) を変更してください。

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

     ※プロキシの設定情報は以下のコマンドで確認できます。

     ```bash
     env | grep -i proxy
     ```

  4. ファイルを保存し、Docker サービスを再起動して設定を反映させます。

     ```bash
     sudo systemctl restart docker
     ```

### 3\. NVIDIA Container Toolkit (Linux のみ)

- **説明**: **Linux ユーザーのみ**が必要です。Linux 上で Docker コンテナが NVIDIA GPU を利用できるようにするためのツールキットです。Windows や Mac では Docker Desktop がこの機能を提供するため、別途インストールは不要です。
- **インストール (Linux)**: ターミナルで以下のコマンドを実行します。

  ```bash
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

  sudo apt-get update
  sudo apt-get install -y nvidia-container-toolkit
  ```

- **設定の反映 (Linux)**: Toolkit をインストールまたはアップデートした後、Docker デーモンを再起動して設定を反映させます。

  ```bash
  sudo systemctl restart docker
  ```

- **確認方法 (Linux)**: 以下のテストコマンドを実行し、エラーなく`nvidia-smi`の出力が表示されれば成功です。

  ```bash
  docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi
  ```

### 4\. Visual Studio Code & Dev Containers 拡張機能

- **説明**: 開発用の高機能エディタと、コンテナ内での開発をシームレスにするための拡張機能です。
- **インストール**:
  1. [Visual Studio Code](https://code.visualstudio.com/)を公式サイトからインストールします。
  2. VS Code を起動し、左側のアクティビティバーから拡張機能タブを開きます。
  3. `Dev Containers`と検索し、`ms-vscode-remote.remote-containers`をインストールします。

---

### 🚀 プロジェクトの起動

すべての前提ソフトウェアの準備が整ったら、以下の手順で開発環境を起動します。

1. このリポジトリをローカルにクローンし、VS Code でプロジェクトフォルダを開きます。

   ```bash
   git clone https://github.com/Shiyo1101/cuda-workspace.git
   cd cuda-workspace
   code .
   ```

2. VS Code が`.devcontainer`フォルダを検出し、ウィンドウの右下に\*\*「Reopen in Container」\*\*という通知が表示されます。このボタンをクリックしてください。

3. 自動的に Docker イメージのビルドとコンテナの起動が開始されます。初回は環境構築のため数分かかる場合があります。

ビルドが完了すると、VS Code のウィンドウがリロードされ、コンテナ内の開発環境に接続された状態になります。

#### 2\. 開発環境の切り替え

このプロジェクトでは、使用するライブラリに応じて複数の開発環境を切り替えることができます。環境を切り替えるには、`.devcontainer/devcontainer.json` ファイルを編集します。

- **TensorFlow 環境**: GPU 対応の TensorFlow がプリインストールされています。(デフォルト)
- **Pytorch 環境**: Pytorch がプリインストールされています。
- **requirements.txt 環境**: `docker/requirements/requirements.txt` に基づいてライブラリがインストールされます。

**編集手順:**

1. `.devcontainer/devcontainer.json` を開きます。
2. `build.dockerfile` の値を、使用したい環境の `Dockerfile` のパスに変更します。
3. (任意) `name` の値を変更すると、VS Code のステータスバーに表示される名前が変わり、どの環境を使っているか分かりやすくなります。

##### 例 1: Pytorch 環境に切り替える場合

```json:/.devcontainer/devcontainer.json
{
    "name": "cuda-pytorch", // 分かりやすいように名前を変更
    "build": {
        "context": "../docker",
        // "tensorflow/Dockerfile" から変更
        "dockerfile": "pytorch/Dockerfile"
    },
    // ... 以降の設定は同じ
}
```

##### 例 2: `requirements.txt` ベースの環境に切り替える場合

`docker/requirements/requirements.txt` にインストールしたいライブラリを記述した上で、以下のように設定します。

```json:/.devcontainer/devcontainer.json
{
    "name": "cuda-requirements", // 分かりやすいように名前を変更
    "build": {
        "context": "../docker",
        // "tensorflow/Dockerfile" から変更
        "dockerfile": "requirements/Dockerfile"
    },
    // ... 以降の設定は同じ
}
```

**【重要】**
`devcontainer.json` を変更した後は、VS Code のコマンドパレット (`Ctrl+Shift+P` または `Cmd+Shift+P`) を開き、**`Dev Containers: Rebuild Container`** を実行してコンテナを再ビルドしてください。これにより、変更が適用された新しい開発環境が起動します。

---

### 🔬 動作確認

環境が正しく構築され、コンテナ内から GPU が利用可能かを確認します。

1. VS Code でコンテナ内のターミナルを開きます (ショートカット: `Ctrl+J` または `Cmd+J`)。

2. ターミナルで以下のコマンドを実行します。

   ```bash
   nvidia-smi
   ```

   ホスト OS で実行した時と同様の GPU 情報が表示されれば、コンテナ内から GPU が正しく認識されています。これで開発の準備は完了です。

---

### 🐍 Python の実行方法

この開発コンテナには、選択した`Dockerfile`に基づき Python の実行環境がプリインストールされています。

- **Python のバージョン**: `python3`がインストールされ、`python`コマンドで直接呼び出せるように設定されています。

- **実行方法**:
  VS Code でコンテナ内のターミナルを開き (`Ctrl+J`)、プロジェクトルート（`/cuda-workspace`）にいることを確認してください。
  `src`フォルダ内に`my_script.py`のような Python ファイルを作成した場合、以下のコマンドで実行できます。

  ```bash
  python src/my_script.py
  ```

- **ライブラリの管理**:
  プリインストールされるライブラリは、選択した開発環境によって異なります。

  - **TensorFlow/Pytorch 環境**: それぞれの `Dockerfile` に主要なライブラリが記述されています。
  - **requirements.txt 環境**: `docker/requirements/requirements.txt` で管理されます。

  もし追加でライブラリが必要になった場合は、コンテナ内のターミナルで`pip install <package-name>`を実行して一時的にインストールできます。恒久的に追加したい場合は、各環境の`Dockerfile`や`requirements.txt`を編集し、コンテナをリビルドしてください。
