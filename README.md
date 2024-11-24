# AgendaProOficial
AgendaPRO é uma aplicação moderna e prática para conectar prestadores de serviços e clientes, facilitando o agendamento de serviços com eficiência e simplicidade!


# 🚀 Passo a Passo Detalhado para Configuração do Ambiente Flutter

## 1️⃣ Instalação e Configuração Inicial

### 🛠️ **Programas Necessários**

#### 🐦 Flutter SDK:
- Baixe e instale a última versão do [Flutter SDK](https://docs.flutter.dev/get-started/install).
- Atualize o Dart SDK, que vem integrado ao Flutter:
  ```bash
  flutter upgrade
  ```

#### 🤖 Android Studio:
- Baixe e instale a última versão do [Android Studio](https://developer.android.com/studio).
- Instale as ferramentas do SDK Android no Android Studio (SDK Manager):
  - Certifique-se de que as APIs mais recentes estão instaladas.

#### ☕ Java Development Kit (JDK):
- Baixe e instale a versão 17 ou superior do [OpenJDK](https://openjdk.org/).
- Configure a variável de ambiente `JAVA_HOME` no Windows.

---

## 2️⃣ Configuração do Flutter no Android Studio

### 🔌 **Configure o Flutter Plugin:**
1. Abra o Android Studio.
2. Vá em `File > Settings > Plugins` e instale os plugins **Flutter** e **Dart**.

### 📱 **Crie ou Configure um Emulador:**
1. Vá em `Tools > Device Manager`.
2. Crie um novo emulador com a API mais recente.

---

## 3️⃣ Teste se o Flutter está Funcionando

No terminal, execute:
```bash
flutter doctor
```
Certifique-se de que todas as dependências estão corretamente configuradas. O resultado do comando acima devera esta ok como o exemplo abaixo

```
Doctor summary (to see all details, run flutter doctor -v):
[√] Flutter (Channel stable, 3.24.5, on Microsoft Windows [versÆo 10.0.22631.4460], locale pt-BR)
[√] Windows Version (Installed version of Windows is version 10 or higher)
[√] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[√] Chrome - develop for the web
[√] Visual Studio - develop Windows apps (Ferramentas de Build do Visual Studio 2019 16.11.38)
[√] Android Studio (version 2024.2)
[√] IntelliJ IDEA Ultimate Edition (version 2024.2)
[√] VS Code (version 1.95.3)
[√] Connected device (3 available)
[√] Network resources
```


# Guia de Configuração para Firebase, Google e Facebook no Flutter

🚀 Este guia irá orientá-lo na configuração de contas e aplicativos nos provedores Firebase, Google e Facebook, além de mostrar como usar o `.env` para armazenar dados sensíveis no projeto.

---

## 🌳 **Usando o Flutter DotEnv**

O Flutter DotEnv é usado para gerenciar variáveis de ambiente de forma segura, evitando expor dados sensíveis (como chaves de API) diretamente no código.

### Por que usar?
- 🔒 Evita exposição de chaves de API no repositório.
- 🔄 Facilita a troca de ambientes (desenvolvimento, produção, etc.).

### Como configurar:

1. Adicione a dependência ao `pubspec.yaml`:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutter_dotenv: ^5.0.2
   ```

2. Crie um arquivo `.env` no diretório raiz do projeto (mesmo nível de `pubspec.yaml`). Exemplo:

   ```env
   FACEBOOK_APP_ID=618762637149280
   FIREBASE_API_KEY=AIzaSyAEr3Y8-EU3FMBhdm6HigG-SrNpE24GSW0
   ```

3. Inclua o `.env` no `.gitignore`:

   ```
   .env
   ```

4. No código, importe e carregue o `.env`:

   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';

   void main() async {
     await dotenv.load();
     runApp(MyApp());
   }
   ```

   Use as variáveis:

   ```dart
   final facebookAppId = dotenv.env['FACEBOOK_APP_ID'];
   ```

---

## 🔥 **Configuração no Firebase** 

1. Acesse [Firebase Console](https://console.firebase.google.com/) e crie um projeto.
2. Adicione o aplicativo Android:
   - Informe o `Nome do Pacote`.
   - Insira o SHA1 do certificado de assinatura.
3. Baixe o arquivo `google-services.json` e mova para `android/app/` no projeto Flutter.
4. Atualize o arquivo `android/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.4.2'
   }
   ```
5. Atualize `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

---

## 🌐 **Configuração no Google** 

1. Acesse [Google Cloud Console](https://console.cloud.google.com/).
2. Crie um projeto e ative a API de autenticação OAuth.
3. Configure as credenciais para `Android`:
   - Insira o `Nome do Pacote`.
   - Adicione o certificado SHA1.
4. Baixe o arquivo `google-services.json`.

---

## 📘 **Configuração no Facebook** 

1. Acesse [Facebook Developers](https://developers.facebook.com/).
2. Crie um novo aplicativo.
3. Vá para **Configurações > Básico** e:
   - Insira o nome do aplicativo.
   - Adicione o ID do pacote.
4. Gere a chave secreta do aplicativo.
5. Ative o **Login do Facebook** e configure as permissões.

---

## 🌟 **Exemplo Completo do `.env`**

```env
FACEBOOK_APP_ID=618762637149280
FIREBASE_API_KEY=AIzaSyAEr3Y8-EU3FMBhdm6HigG-SrNpE24GSW0
GOOGLE_CLIENT_ID=your-google-client-id
```

---

💡 **Contribuição:** Este guia foi criado para ajudar os colaboradores do projeto a configurarem os provedores e a manterem a segurança de dados sensíveis.

Pronto! 🎉 Seu ambiente de desenvolvimento está configurado para começar a desenvolver projetos incríveis com **Flutter** e **Dart**!
