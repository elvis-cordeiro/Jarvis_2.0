# 🤖 Jarvis — Assistente Pessoal com IA

> Assistente pessoal inteligente inspirado no **J.A.R.V.I.S.** do Homem de Ferro, desenvolvido com **Flutter**, múltiplos provedores de Inteligência Artificial e memória persistente em nuvem.

---

## 🚀 Sobre o Projeto

O **Jarvis** é um assistente pessoal desenvolvido para oferecer uma experiência inteligente, contínua e personalizada entre dispositivos.

O sistema utiliza múltiplos modelos de IA, memória persistente em PostgreSQL, síntese de voz e reconhecimento de fala, garantindo alta disponibilidade através de um sistema de fallback automático entre diferentes provedores de IA.

---

## 🧠 Arquitetura de Memória

O Jarvis possui três níveis de memória persistente armazenados em PostgreSQL:

| Tipo | Finalidade | Retenção |
|-------|------------|-----------|
| 🟢 Permanente | Personalidade, identidade e preferências do usuário | Nunca expira |
| 🟡 Longo Prazo | Informações importantes e históricos | Até 10 anos |
| 🔵 Curto Prazo | Conversas recentes e rotina diária | Até 3 meses |

As memórias ficam disponíveis em qualquer navegador ou dispositivo, permitindo continuidade total das conversas.

---

## 🤖 Redundância de IA

Caso um provedor fique indisponível, o sistema alterna automaticamente para o próximo.

1. 🟢 Google Gemini *(Principal)*
2. 🟡 OpenRouter *(Llama • Mistral • Qwen)*
3. 🔵 SambaNova *(Llama 70B)*
4. 🟣 Cloudflare AI
5. ⚫ HuggingFace

Essa arquitetura garante maior disponibilidade e confiabilidade.

---

## 🎙️ Voz

### Síntese de Voz

- 🎤 ElevenLabs (voz principal)
- 🔄 Flutter TTS (fallback automático em pt-BR)

### Reconhecimento de Fala

- 🌐 Web Speech API
- 🇧🇷 Suporte completo para Português (Brasil)

---

# 🏗️ Stack Tecnológica

| Camada | Tecnologia |
|----------|------------|
| Frontend | Flutter Web / Mobile Adaptativo |
| Backend | Dart + Shelf |
| Banco de Dados | PostgreSQL |
| Cache Local | Drift + SQLite |
| Proxy/CORS | Cloudflare Worker |
| Hospedagem Web | Cloudflare Pages |
| Hospedagem API | Render |
| IA Principal | Google Gemini |
| Voz | ElevenLabs / Web Speech |

---

# ✨ Funcionalidades

- 💬 Chat inteligente com contexto persistente
- 🧠 Memória em três níveis
- ☁️ Banco de dados centralizado na nuvem (mesmo histórico no PC e Mobile)
- 🎙️ Entrada por voz com botão e indicador em tempo real
- 🔊 Respostas em áudio com controle de reprodução
- 📎 Leitura de imagens
- 📄 Análise de PDFs
- 📝 Processamento de documentos de texto
- 🌐 Funcionamento em qualquer navegador (PC e Mobile)
- 📡 Sincronização automática entre dispositivos
- ⚡ Sistema de fallback automático entre IAs
- 🔄 API sempre ativa utilizando Cloudflare Worker

---

# 🔒 Segurança

- 🔐 Chaves de API protegidas como **Secrets** no Cloudflare Worker
- 🚫 Nenhuma chave sensível exposta no frontend
- 🛡️ Proxy seguro para CORS
- ☁️ Comunicação protegida entre frontend e backend

---

# 📂 Estrutura do Projeto

```text
lib/
├── core/
│   ├── providers/
│   └── services/
│
├── data/
│   ├── database/
│   └── repositories/
│
├── domain/
│   ├── services/
│   └── usecases/
│
└── presentation/
    └── ChatScreen

jarvis_api/
```

---

# 🌐 Deploy & Execução Web/Mobile

### API
https://api-render-bomf.onrender.com

### Como Rodar no Navegador (PC & Celular):

```bash
# 1. Habilitar web no Flutter
flutter config --enable-web

# 2. Obter dependências
flutter pub get

# 3. Rodar em modo desenvolvimento no Chrome
flutter run -d chrome

# 4. Gerar build otimizada para produção (Cloudflare Pages / Vercel / Netlify)
flutter build web --release
```

> [!TIP]
> **Acesso Seguro no Celular (HTTPS):** Para que o microfone funcione nos navegadores móveis (Safari no iOS e Chrome no Android), o acesso deve ser via HTTPS. O deploy no **Cloudflare Pages** fornece certificado SSL/HTTPS gratuitamente.

---

# 🚀 Diferenciais

- ✅ Arquitetura Multi-AI
- ✅ Memória Persistente
- ✅ Sincronização em Nuvem
- ✅ Funcionamento entre dispositivos (PC e Mobile)
- ✅ Entrada e saída por voz
- ✅ Sistema de redundância automática
- ✅ Cache local inteligente
- ✅ Backend próprio em Dart

---

# 👨‍💻 Desenvolvedor

## Elvis Cordeiro

Desenvolvedor em transição para a área de Dados e Desenvolvimento de Software, com foco em Inteligência Artificial, Backend, Banco de Dados e soluções escaláveis.

### Tecnologias

- Flutter
- Dart
- Java
- PostgreSQL
- SQL
- Node.js
- React
- TypeScript
- Docker
- Cloudflare Workers
- Render
- Git
- GitHub

---

## 📄 Licença

Este projeto foi desenvolvido para fins de estudo, pesquisa e demonstração de competências em desenvolvimento de software e Inteligência Artificial.
